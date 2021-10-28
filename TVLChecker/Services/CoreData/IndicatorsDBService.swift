import Combine
import CoreData

protocol IndicatorsDBService {
  func hasLoadedItems() -> AnyPublisher<Bool, Error>
  
  func saveDataToCoreData(items: [Item]) -> AnyPublisher<Void, Error>
  
  func indicators(searchText: String) -> AnyPublisher<[String], Error>
}


struct RealIndicatorsDBService: IndicatorsDBService {
  let persistentStore: PersistentStore
  
  init(_ persistentStore: PersistentStore) {
    self.persistentStore = persistentStore
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
  
  func indicators(searchText: String) -> AnyPublisher<[String], Error> {
    
    let fetchRequest = ItemModelObject.itemsList(searchText: searchText)
    
    return persistentStore
      .fetch(fetchRequest) { fetchedIndicators in
        Item(managedObject: fetchedIndicators)
      }
      .map { items in
        var uniquedIndicatorsList: [String] = []
        
        for item in items {
          uniquedIndicatorsList.append(item.indicator)
        }
        
        return uniquedIndicatorsList.uniqued()
      }
      .eraseToAnyPublisher()
  }
}

//protocol ItemsDBRepository {
//
//  func hasLoadedItems() -> AnyPublisher<Bool, Error>
//
//  func items(indicator: String) -> AnyPublisher<LazyList<Item>, Error>
//
//  func indicators(searchText: String) -> AnyPublisher<[String], Error>
//
//  func saveDataToCoreData(items: [Item]) -> AnyPublisher<Void, Error>
//
//  func clearCoreData()
//}
//
//struct RealItemsDBRepository: ItemsDBRepository {
//
//  let persistentStore: PersistentStore
//
//  func hasLoadedItems() -> AnyPublisher<Bool, Error> {
//    let fetchRequest = ItemModelObject.justOneItem()
//
//    return persistentStore
//      .count(fetchRequest)
//      .map { $0 > 0 }
//      .eraseToAnyPublisher()
//  }
//
//  func saveDataToCoreData(items: [Item]) -> AnyPublisher<Void, Error> {
//    return persistentStore
//      .update { context in
//        items.forEach {
//          $0.modelToObjectWithin(context)
//        }
//      }
//  }
//
//  func items(indicator: String) -> AnyPublisher<LazyList<Item>, Error> {
//    let fetchRequest = ItemModelObject.itemsList(by: indicator)
//
//    return persistentStore
//      .fetch(fetchRequest) {
//        Item(managedObject: $0)
//      }
//      .eraseToAnyPublisher()
//  }
//
//  func indicators(searchText: String) -> AnyPublisher<[String], Error> {
//
//    let fetchRequest = ItemModelObject.itemsList(searchText: searchText)
//
//    return persistentStore
//      .fetch(fetchRequest) { fetchedIndicators in
//        Item(managedObject: fetchedIndicators)
//      }
//      .map { items in
//        var uniquedIndicatorsList: [String] = []
//
//        for item in items {
//          uniquedIndicatorsList.append(item.indicator)
//        }
//
//        return uniquedIndicatorsList.uniqued()
//      }
//      .eraseToAnyPublisher()
//  }
//
//  func clearCoreData() {
//
//    let cancelBag = CancelBag()
//
//    persistentStore.clearDataBaseBy(entity: "ItemModelObject")
//      .sink { _ in } receiveValue: { _ in }
//      .store(in: cancelBag)
//  }
//}
