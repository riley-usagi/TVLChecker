import Combine

/// Мешок для подписок
final class CancelBag {
  
  /// Уникальный список с подписками на всевозможные издатели
  var subscriptions = Set<AnyCancellable>()
  
  /// Уничтожение подписок
  func cancel() {
    subscriptions.removeAll()
  }
}
