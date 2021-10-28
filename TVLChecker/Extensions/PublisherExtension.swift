import Combine
import Foundation

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
  
  /// Процесс обработки полученного ранее Json'а
  /// - Parameter httpCodes: Диапазон разрешённых кодов ответа от сервера
  /// - Returns: AnyPublisher с данными после процесса декодирования Json'а
  func requestJSON<Value>(httpCodes: HTTPCodes) -> AnyPublisher<Value, Error> where Value: Decodable {
    
    let decoder = JSONDecoder()
//    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    
    return tryMap { output in
      
      assert(!Thread.isMainThread)
      
      /// Код ответа от сервера
      guard let code = (output.response as? HTTPURLResponse)?.statusCode else {
        throw APIError.unexpectedResponse
      }
      
      // Проверка на то, что код удовлетворяет требованиям
      guard httpCodes.contains(code) else {
        throw APIError.httpCode(code)
      }
      
      return output.data
    }
    .decode(type: Value.self, decoder: decoder)
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
  }
}


extension Publisher {
  
  /// Вынести основную ошибку
  /// - Returns: Объект ошибки
  func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
    mapError {
      ($0.underlyingError as? Failure) ?? $0
    }
  }
  
  /// Метод добавления процесса ожидания ответа от сервера
  /// - Parameter interval: Интервал ошидания
  /// - Returns: Издатель с задержкой
  func ensureTimeSpan(_ interval: TimeInterval) -> AnyPublisher<Output, Failure> {
    
    let timer = Just<Void>(())
      .delay(for: .seconds(interval), scheduler: RunLoop.main)
      .setFailureType(to: Failure.self)
    
    return zip(timer)
      .map { $0.0 }
      .eraseToAnyPublisher()
  }
  
  
  /// Процесс сохранения данных в Loadable-объект
  /// - Parameter completion: Сбегающее замыкание с полученными асинхронно данными
  /// - Returns: Объект подписки
  func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
    
    return sink(receiveCompletion: { subscriptionCompletion in
      if let error = subscriptionCompletion.error {
        completion(.failed(error))
      }
    }, receiveValue: {value in
      completion(.loaded(value))
    })
  }
  
  /// Процесс сохранения данных в формате Result
  /// - Parameter result: Результат получения данных
  /// - Returns: Данные в формате Result
  func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
    
    return sink(receiveCompletion: { completion in
      
      switch completion {
      
      case let .failure(error):
        result(.failure(error))
      default: break
      }
    }, receiveValue: { value in
      result(.success(value))
    })
  }
}
