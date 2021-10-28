import Combine

extension Just where Output == Void {
  
  /// Заглушка для Just с тимпом данных Void
  /// - Parameter errorType: Тп ошибки
  /// - Returns: Обёртка AnyPublisher для Just, с подменённым типом ошибки
  static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
    return withErrorType((), E.self)
  }
}

extension Just {
  
  /// Заглушка здля издателя Just
  /// - Parameters:
  ///   - value: Значение идателя
  ///   - errorType: Тип ошибки
  /// - Returns: Обёртка AnyPublisher для Just, с подменённым типом ошибки
  static func withErrorType<E>(_ value: Output, _ errorType: E.Type) -> AnyPublisher<Output, E> {
    
    return Just(value)
      .setFailureType(to: E.self)
      .eraseToAnyPublisher()
  }
}
