import Combine
import SwiftUI

typealias Store<State> = CurrentValueSubject<State, Never>

/// Обёртка для превращения AppState в динамический объект благодаря COmbine
extension Store {
  
  // Обращение по сабскрипту
  subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
    
    get { value[keyPath: keyPath] }
    
    set {
      
      var value = self.value
      
      if value[keyPath: keyPath] != newValue {
        value[keyPath: keyPath] = newValue
        self.value = value
      }
    }
  }
  
  /// Массовое обновление объекта
  /// - Parameter update: Значение обновления
  func bunkUpdate(_ update: (inout Output) -> Void) {
    
    var value = self.value
    
    update(&value)
    
    self.value = value
  }
  
  /// Подписка на обновления данных по ключам
  /// - Parameter keyPath: Ключ объекта
  /// - Returns: Объект издателя
  func updates<Value>(for keyPath: KeyPath<Output, Value>) ->
  AnyPublisher<Value, Failure> where Value: Equatable {
    
    return map(keyPath).removeDuplicates().eraseToAnyPublisher()
  }
}
