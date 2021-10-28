import Foundation

/// Список с "ленивыми" данными
struct LazyList<T> {
  
  typealias Access = (Int) throws -> T?
  
  private let access: Access
  
  private let useCache: Bool
  
  private var cache = Cache()
  
  let count: Int
 
  init(count: Int, useCache: Bool, _ access: @escaping Access) {
    self.count    = count
    self.useCache = useCache
    self.access   = access
  }
  
  /// Доступ к элементу ленивого списка
  /// - Parameter index: Индекс обращения
  /// - Throws: Возможная ошибка
  /// - Returns: Элемент
  func element(at index: Int) throws -> T {
    
    guard useCache else {
      return try get(at: index)
    }
    
    return try cache.sync { elements in
      
      if let element = elements[index] {
        return element
      }
      
      let element = try get(at: index)
      
      elements[index] = element
      
      return element
    }
  }
  
  private func get(at index: Int) throws -> T {
    
    guard let element = try access(index) else {
      throw Error.elementIsNil(index: index)
    }
    
    return element
  }
}


extension LazyList {
  enum Error: LocalizedError {
    case elementIsNil(index: Int)
    
    var localizedDescription: String {
      switch self {
      case let .elementIsNil(index: index):
        return "Element at index \(String(describing: index)) is nil"
      }
    }
  }
}


// MARK: - Random Access Collection

extension LazyList: RandomAccessCollection {

  typealias Index = Int

  var startIndex: Index { 0 }
  var endIndex: Index { count }

  subscript(index: Index) -> Iterator.Element {

    do {
      return try element(at: index)
    } catch let error {
      fatalError("\(error)")
    }
  }
}
