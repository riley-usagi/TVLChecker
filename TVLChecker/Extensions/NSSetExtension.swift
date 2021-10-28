import Foundation

extension NSSet {
  
  /// Уникальная коллекция в Массив
  /// - Parameter type: Типа данных коллекции
  /// - Returns: Массив типа данных
  func toArray<T>(of type: T.Type) -> [T] {
    allObjects.compactMap { $0 as? T }
  }
}
