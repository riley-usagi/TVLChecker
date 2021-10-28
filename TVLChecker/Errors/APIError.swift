import Foundation

/// Список возможных ошибок относительно сетевых запросов
enum APIError: Swift.Error {
  
  /// Неправильная ссылка
  case invalidURL
  
  /// Не подоходящий код ответа
  case httpCode(Int)
  
  /// неожиданный ответ от сервера
  case unexpectedResponse
  
  /// Ошибка обработки изображения
  case imageProcessing([URLRequest])
  
  case layeringError
  
  var errorDescription: String? {
    switch self {
    
    case .invalidURL:
      return "Invalid URL"
    case let .httpCode(code):
      return "Unexpected HTTP code: \(code)"
    case .unexpectedResponse:
      return "Unexpected response from server"
    case .imageProcessing:
      return "Unable to load image"
    case .layeringError:
      return "Вы не можете создать цикл, потому что его даты пересекаются с существующим."
    }
  }
  
}
