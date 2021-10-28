import Combine
import SwiftUI

protocol IndicatorsInteractor {
  func loadIndicatorsList(_ indicators: LoadableSubject<[String]>, searchText: String)
}


struct RealIndicatorsInteractor: IndicatorsInteractor {
  
  /// Мешок для подписок
  let cancelBag = CancelBag()
  
  let dbService: IndicatorsDBService
  let fbService: ItemsFBService
  
  func loadIndicatorsList(_ indicators: LoadableSubject<[String]>, searchText: String) {
    
    indicators.wrappedValue.setIsLoading(cancelBag: cancelBag)
    
    Just<Void>
      .withErrorType(Error.self)
    
      .flatMap { [dbService] _ -> AnyPublisher<Bool, Error> in
        dbService.hasLoadedItems()
      }
    
      .flatMap { hasLoaded -> AnyPublisher<Void, Error> in
        if hasLoaded {
          return Just<Void>.withErrorType(Error.self)
        } else {
          return refreshItemsList()
        }
      }
    
      .flatMap { [dbService] in
        dbService.indicators(searchText: searchText)
      }
    
      .sinkToLoadable {
        indicators.wrappedValue = $0
      }
    
      .store(in: cancelBag)
  }
  
  func refreshItemsList() -> AnyPublisher<Void, Error> {
    return fbService
      .loadItems()
      .flatMap { [dbService] in
        dbService.saveDataToCoreData(items: $0)
      }
      .eraseToAnyPublisher()
  }
}

struct StubIndicatorsInteractor: IndicatorsInteractor {
  func loadIndicatorsList(_ indicators: LoadableSubject<[String]>, searchText: String) {}
}
