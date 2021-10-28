import Foundation

extension LazyList {
  
  /// Кэш для ленивого списка
  class Cache {
    
    private var elements = [Int: T]()
    
    /// Доступ к элементам ленивого списка с ипользованием Кэша
    /// - Parameter access: Объект доступа
    /// - Throws: Возможная ошибка
    /// - Returns: Элемент
    func sync(_ access: (inout [Int: T]) throws -> T) throws -> T {
      
      guard Thread.isMainThread else {
        
        var result: T!
        
        try DispatchQueue.main.sync {
          result = try access(&elements)
        }
        
        
        return result
      }
      
      return try access(&elements)
    }
  }
}
