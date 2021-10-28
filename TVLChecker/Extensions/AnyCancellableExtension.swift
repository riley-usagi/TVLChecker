import Combine

extension AnyCancellable {
  
  /// Метод сохранения подписок на издатели в мешке для подписок
  /// - Parameter cancelBag: Объект мешка для подписок
  func store(in cancelBag: CancelBag) {
    cancelBag.subscriptions.insert(self)
  }
}
