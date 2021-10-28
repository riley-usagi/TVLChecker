import Combine
import SwiftUI

protocol ItemsInteractor {
  func clearCoreData()
  func loadItems(_ items: LoadableSubject<LazyList<Item>>, _ searchQuery: String)
}

struct RealItemsInteractor: ItemsInteractor {
  
  let cancelBag = CancelBag()
  
  let dbService: ItemsDBService
  let fbService: ItemsFBService
  
  init(_ dbService: ItemsDBService, _ fbService: ItemsFBService) {
    self.dbService = dbService
    self.fbService = fbService
  }
  
  func clearCoreData() {
    dbService.clearCoreData()
  }
  
  func loadItems(_ items: LoadableSubject<LazyList<Item>>, _ searchQuery: String) {
    items.wrappedValue.setIsLoading(cancelBag: cancelBag)
    
    
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
        dbService.items(query: searchQuery)
      }
    
      .sinkToLoadable { loadedItemsFromCoreData in
        items.wrappedValue = loadedItemsFromCoreData
      }
    
      .store(in: cancelBag)
  }
}


// MARK: - Helpers

extension RealItemsInteractor {
  
  func refreshItemsList() -> AnyPublisher<Void, Error> {
    
    return fbService
      .loadItems()
      .flatMap { [dbService] in
        dbService.saveDataToCoreData(items: $0)
      }
      .eraseToAnyPublisher()
  }
}


// MARK: - Stub

struct StubItemsInteractor: ItemsInteractor {
  func clearCoreData() {}
  func loadItems(_ items: LoadableSubject<LazyList<Item>>, _ searchQuery: String) {}
}
