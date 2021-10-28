import Combine
import CoreData

protocol PersistentStore {
  
  typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
  
  func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error>
  
  /// Подписка на получение данных из CoreData
  /// - Parameters:
  ///   - fetchRequest: Объект запроса к базе данных
  ///   - map: Замыкание для обработки полученных данных
  func fetch<T, V>(
    _ fetchRequest: NSFetchRequest<T>,
    map: @escaping (T) throws -> V?
  ) -> AnyPublisher<LazyList<V>, Error>
  
  func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error>
  
  func clearDataBaseBy(entity: String) -> AnyPublisher<Void, Error>
}

struct CoreDataStack: PersistentStore {
  
  
  // MARK: - Variables
  
  private let container: NSPersistentContainer
  private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
  private let bgQueue = DispatchQueue(label: "coredata")
  
  private var onStoreIsReady: AnyPublisher<Void, Error> {
    return isStoreLoaded
      .filter {
        $0
      }
      .map { _ in }
      .eraseToAnyPublisher()
  }
  
  
  // MARK: - Initializers
  
  init(
    directory: FileManager.SearchPathDirectory = .documentDirectory,
    domainMask: FileManager.SearchPathDomainMask = .userDomainMask
  ) {
    
    container = NSPersistentContainer(name: "TVLCheckerDataBase")
    
    if let url = dbFileURL(directory, domainMask) {
      let store = NSPersistentStoreDescription(url: url)
      container.persistentStoreDescriptions = [store]
    }
    
    bgQueue.async { [weak isStoreLoaded, weak container] in
      
      container?.loadPersistentStores(completionHandler: { (storeDescription, error) in
        
        DispatchQueue.main.async {
          if let error = error {
            isStoreLoaded?.send(completion: .failure(error))
          } else {
            container?.viewContext.configureAsReadOnlyContext()
            isStoreLoaded?.value = true
          }
        }
      })
    }
  }
  
  
  // MARK: - Methods
  /// Путь до локального файла базы данных CoreData
  /// - Parameters:
  ///   - directory: Путь
  ///   - domainMask: Маска пути
  /// - Returns: Путь до локального файла базы данных
  func dbFileURL(_ directory: FileManager.SearchPathDirectory,
                 _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
    return FileManager.default
      .urls(for: directory, in: domainMask).first?
      .appendingPathComponent("db.sql")
  }
  
  func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> {
    return onStoreIsReady
      .flatMap { [weak container] in
        Future<Int, Error> { promise in
          do {
            let count = try container?.viewContext.count(for: fetchRequest) ?? 0
            promise(.success(count))
          } catch {
            promise(.failure(error))
          }
        }
      }
      .eraseToAnyPublisher()
  }
  
  func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error> {
    
    // Проверка на то, что процесс идёт в основном потоке
    assert(Thread.isMainThread)
    
    /// Объект Издателя, который отдаёт данные лишь раз, но с обработкой ошибки
    let fetch = Future<LazyList<V>, Error> { [weak container] promise in
      
      guard let context = container?.viewContext else { return }
      
      context.performAndWait {
        
        do {
          
          let managedObjects = try context.fetch(fetchRequest)
          
          let results = LazyList<V>(count: managedObjects.count, useCache: true) { [weak context] in
            
            let object = managedObjects[$0]
            
            let mapped = try map(object)
            
            if let modelObject = object as? NSManagedObject {
              context?.refresh(modelObject, mergeChanges: false)
            }
            
            return mapped
          }
          
          promise(.success(results))
        } catch {
          promise(.failure(error))
        }
      }
    }
    
    return onStoreIsReady
      .flatMap { fetch }
      .eraseToAnyPublisher()
  }
  
  func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
    
    let update = Future<Result, Error> { [weak bgQueue, weak container] promise in
      bgQueue?.async {
        guard let context = container?.newBackgroundContext() else { return }
        
        context.configureAsReadOnlyContext()
        
        context.performAndWait {
          
          do {
            let result = try operation(context)
            
            if context.hasChanges {
              try context.save()
            }
            
            context.reset()
            promise(.success(result))
          } catch {
            context.reset()
            promise(.failure(error))
          }
        }
      }
    }
    
    return onStoreIsReady
      .flatMap { update }
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
  
  /// Метод зачистки базы данных
  func clearDataBaseBy(entity: String) -> AnyPublisher<Void, Error> {
    
    let delete = Future<Void, Error> { [weak bgQueue, weak container] promise in
      bgQueue?.async {
        guard let context = container?.newBackgroundContext() else { return }
        
        context.performAndWait {
          
          let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
          let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
          
          do {
            try context.execute(deleteRequest)
            try context.save()
            promise(.success(Void()))
          } catch {
            promise(.failure(error))
          }
        }
      }
    }
    
    return delete
      .eraseToAnyPublisher()
  }
}
