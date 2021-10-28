import Foundation

protocol SomeOptional {
  associatedtype Wrapped
  
  func unwrap() throws -> Wrapped
}

extension Optional: SomeOptional {
  
  /// Извлечение опционального типа
  /// - Throws: Возможная ошибка
  /// - Returns: Развёрнутое значение
  func unwrap() throws -> Wrapped {
    
    switch self {
    
    case .none:
      throw ValueIsMissing()
    case let .some(value):
      return value
    }
  }
}

struct ValueIsMissing: Error {
  
  /// Ошибка отсутствия данных
  var localizedMissingDescription: String {
    NSLocalizedString("Data is missing", comment: "")
  }
}
