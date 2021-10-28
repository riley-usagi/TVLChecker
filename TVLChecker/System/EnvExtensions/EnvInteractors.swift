// MARK: - Interactors
extension AppEnvironment {
  
  /// Обрабатываем и возвращаем список всех интеракторов приложения
  /// - Parameter appState: Объект хранилища данных
  /// - Returns: Список настроенных Интеракторов
  static func configuredInteractors(
    _ appState: Store<AppState>,
    _ dbServices: Container.DBServices,
    _ fbServices: Container.FBServices
  ) -> Container.Interactors {
    
    let itemsInteractor = RealItemsInteractor(
      dbServices.itemsDBService, fbServices.itemsFBService
    )
    
    return .init(itemsInteractor)
  }
}
