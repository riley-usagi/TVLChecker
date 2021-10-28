import Combine
import SwiftUI

protocol IndicatorsInteractor {
  func loadIndicatorsList(_ indicators: LoadableSubject<[String]>, searchText: String)
}


struct RealIndicatorsInteractor: IndicatorsInteractor {
  
  /// Мешок для подписок
  let cancelBag = CancelBag()
  
//  let itemsDBRepository: ItemsDBRepository
  let dbService: IndicatorsDBService
  
  func loadIndicatorsList(_ indicators: LoadableSubject<[String]>, searchText: String) {
    
    indicators.wrappedValue.setIsLoading(cancelBag: cancelBag)
    
    Just<Void>
      .withErrorType(Error.self)
    
//    Just<Void>
//      .withErrorType(Error.self)
//      .flatMap { [itemsDBRepository] _ -> AnyPublisher<Bool, Error> in
//        itemsDBRepository.hasLoadedItems()
//      }
//      .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
//        if hasLoaded {
//          return Just<Void>.withErrorType(Error.self)
//        } else {
//          return refreshItemsList()
//        }
//      }
//      .flatMap { [itemsDBRepository] in
//        itemsDBRepository.items(indicator: indicator)
//      }
//      .sinkToLoadable { items.wrappedValue = $0 }
//      .store(in: cancelBag)
    
  }
}

struct StubIndicatorsInteractor: IndicatorsInteractor {
  func loadIndicatorsList(_ indicators: LoadableSubject<[String]>, searchText: String) {
    
  }
}
