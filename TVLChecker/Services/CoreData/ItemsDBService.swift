import Combine
import CoreData

protocol ItemsDBService {
  func clearCoreData()
  
  func hasLoadedItems() -> AnyPublisher<Bool, Error>
  
  func saveDataToCoreData(items: [Item]) -> AnyPublisher<Void, Error>
  
  func items(query: String) -> AnyPublisher<LazyList<Item>, Error>
}

struct RealItemsDBService: ItemsDBService {
  
  let persistentStore: PersistentStore
  
  init(_ persistentStore: PersistentStore) {
    self.persistentStore = persistentStore
  }
  
  func clearCoreData() {
    
    let cancelBag = CancelBag()
    
    persistentStore.clearDataBaseBy(entity: "ItemModelObject")
      .sink { _ in } receiveValue: { _ in }
      .store(in: cancelBag)
  }
  
  func hasLoadedItems() -> AnyPublisher<Bool, Error> {
    let fetchRequest = ItemModelObject.justOneItem()
    
    return persistentStore
      .count(fetchRequest)
      .map { $0 > 0 }
      .eraseToAnyPublisher()
  }
  
  func saveDataToCoreData(items: [Item]) -> AnyPublisher<Void, Error> {
    return persistentStore
      .update { context in
        items.forEach {
          $0.modelToObjectWithin(context)
        }
      }
  }
  
  func items(query: String) -> AnyPublisher<LazyList<Item>, Error> {
    let fetchRequest = ItemModelObject.itemsList(searchText: query)
    
    return persistentStore
      .fetch(fetchRequest) {
        Item(managedObject: $0)
      }
      .eraseToAnyPublisher()
  }
}
