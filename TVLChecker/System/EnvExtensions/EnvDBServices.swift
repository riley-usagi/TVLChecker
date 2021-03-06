// MARK: - CoreData repositories
extension AppEnvironment {
  
  /// Обрабатываем и возвращаем список всех репозиториев для работы с CoreData
  /// - Returns: Список настроенных CoreData-репозиториев
  static func configuredDBServices() -> Container.DBServices {
    
    let persistentStore = CoreDataStack()
    
    let itemsDBService = RealItemsDBService(persistentStore)
    
    return .init(itemsDBService)
  }
}
