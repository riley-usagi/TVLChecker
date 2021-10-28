extension Container {
  
  /// Список интеракторов
  struct Interactors {
    
    let itemsInteractor: ItemsInteractor
    
    /// Заглушка
    static var stub: Self {
      .init(
        StubItemsInteractor()
      )
    }
    
    init(
      _ itemsInteractor: ItemsInteractor
    ) {
      self.itemsInteractor = itemsInteractor
    }
  }
}
