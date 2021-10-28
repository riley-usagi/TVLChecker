extension Container {
  
  /// Список интеракторов
  struct Interactors {
    
    let indicatorsInteractor: IndicatorsInteractor
    
    /// Заглушка
    static var stub: Self {
      .init(
        StubIndicatorsInteractor()
      )
    }
    
    init(
      _ indicatorsInteractor: IndicatorsInteractor
    ) {
      self.indicatorsInteractor = indicatorsInteractor
    }
  }
}
