extension Container {
  
  struct FBServices {
    
    let itemsFBService: ItemsFBService
    
    init(
      _ itemsFBService: ItemsFBService
    ) {
      self.itemsFBService = itemsFBService
    }
  }
}
