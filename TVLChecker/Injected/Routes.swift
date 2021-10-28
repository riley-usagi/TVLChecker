import Foundation

extension Container {
  
  enum Routes: Equatable {
    
    case indicators
    
    case loading
    
//    case editCycle(_ id: Int)
    
    var title: String {
      switch self {
      
      case .loading:
        return "Загрузка"
      case .indicators:
        return "Показатели"
      }
    }
  }
}
