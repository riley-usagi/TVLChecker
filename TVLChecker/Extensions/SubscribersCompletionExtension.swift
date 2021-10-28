import Combine

extension Subscribers.Completion {
  
  /// Ошибка для подписок
  var error: Failure? {
    switch self {
    
    case let .failure(error): return error
    default: return nil
    }
  }
}
