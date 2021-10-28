// MARK: - CoreData Services

extension Container {
  
  struct DBServices {
    
    let itemsDBService: ItemsDBService
    
    init(_ itemsDBService: ItemsDBService) {
      self.itemsDBService = itemsDBService
    }
  }
}
