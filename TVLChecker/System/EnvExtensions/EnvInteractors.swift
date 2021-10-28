// MARK: - Interactors
extension AppEnvironment {
  
  /// Обрабатываем и возвращаем список всех интеракторов приложения
  /// - Parameter appState: Объект хранилища данных
  /// - Returns: Список настроенных Интеракторов
  static func configuredInteractors(
    appState: Store<AppState>,
    dbServices: Container.DBServices
//    fbRepositories: Container.FBRepositories,
//    dbRepositories: Container.DBRepositories
  ) -> Container.Interactors {
    
    let indicatorsInteractor = RealIndicatorsInteractor(
      dbService: dbServices.indicatorsDBService
    )
    
    
    return .init(indicatorsInteractor)
  }
}
