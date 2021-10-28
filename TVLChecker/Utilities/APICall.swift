import Foundation

/// Протокол запроса к удалённому сервера
protocol APICall {
  
  /// Путь
  var path: String { get }
  
  /// Метод
  var method: String { get }
  
  /// Заголовки
  var headers: [String: String]? { get }
  
  /// Тело запроса
  func body() throws -> Data?
}

extension APICall {
  
  /// Настроенный объект запроса
  /// - Parameter baseUrl: Базовый URL
  /// - Throws: Возможная ошибка
  /// - Returns: Объект запроса к удалённому серверу
  func urlRequest(baseUrl: String) throws -> URLRequest {
    
    guard let url = URL(string: baseUrl + path) else {
      throw APIError.invalidURL
    }
    
    var request = URLRequest(url: url)
    
    request.httpMethod          = method
    request.allHTTPHeaderFields = headers
    request.httpBody            = try body()
    
    return request
  }
}
