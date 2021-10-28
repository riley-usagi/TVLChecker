import Foundation

extension LazyList: Sequence {
  
  /// Инструмент для безопасного перебора ленивого списка
  struct Iterator: IteratorProtocol {
    
    typealias Element = T
    
    private var index = -1
    
    private var list: LazyList<Element>
    
    init(list: LazyList<Element>) {
      self.list = list
    }
    
    mutating func next() -> Element? {
      index += 1
      
      guard index < list.count else {
        return nil
      }
      
      do {
        return try list.element(at: index)
      } catch _ {
        return nil
      }
    }
  }
  
  func makeIterator() -> Iterator {
    .init(list: self)
  }
  
  var underestimatedCount: Int { count }
}
