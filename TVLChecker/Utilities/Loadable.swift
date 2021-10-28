import Combine
import SwiftUI

typealias LoadableSubject<Value> = Binding<Loadable<Value>>

/// Загружаемый объект имеющий внетренее значение и четыре статуса состояния
enum Loadable<T> {
  
  
  /// Объект не запрошен
  case notRequested
  
  /// Объект в процессе загрузки данных
  case isLoading(last: T?, cancelBag: CancelBag)
  
  /// Объект успешно загружен с данными
  case loaded(T)
  
  /// Объект загружен с ошибкой
  case failed(Error)
  
  
  /// Содержимое загружаемого объекта
  var value: T? {
    switch self {
    case let .isLoading(last, _): return last
    default: return nil
    }
  }
}

extension Loadable {
  
  /// Изменение статуса загружаемого объекта на - Загружается
  /// - Parameter cancelBag: мешок для пописок (если процесс прервался)
  mutating func setIsLoading(cancelBag: CancelBag) {
    self = .isLoading(last: value, cancelBag: cancelBag)
  }
  
  /// Обработка данных в загружаемомо объекте через передаваемое замыкание
  /// - Parameter transform: Объект замыкания
  /// - Returns: Загружаемый объект после обработки замыканием
  func map<V>(_ transform: (T) throws -> V) -> Loadable<V> {
    do {
      
      switch self {
      
      case .notRequested: return .notRequested
      case let .isLoading(value, cancelBag):
        return .isLoading(last: try value.map { try transform($0) }, cancelBag: cancelBag)
      case let .loaded(value):
        return .loaded(try transform(value))
      case let .failed(error):
        return .failed(error)
      }
      
    } catch {
      return .failed(error)
    }
  }
}

extension Loadable where T: SomeOptional {
  
  /// Процесс разворачивания загружаемого объекта с опциональными данными
  /// - Returns: <#description#>
  func unwrap() -> Loadable<T.Wrapped> {
    map { try $0.unwrap() }
  }
}
