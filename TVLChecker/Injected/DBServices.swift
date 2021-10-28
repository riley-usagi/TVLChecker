// MARK: - CoreData Services

extension Container {
  
  struct DBServices {
    
    let indicatorsDBService: IndicatorsDBService
    
    init(_ indicatorsDBService: IndicatorsDBService) {
      self.indicatorsDBService = indicatorsDBService
    }
  }
}
