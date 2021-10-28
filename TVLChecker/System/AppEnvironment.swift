/// Окружение приложения
struct AppEnvironment {
  let container: Container
}

extension AppEnvironment {
  
  // MARK: - Bootstrap
  
  /// Основной метод первоначальной настройки всего и вся
  /// - Returns: Объект окружения
  static func bootstrap() -> AppEnvironment {
    
    let appState        = Store<AppState>(AppState())
    
    let dbServices = configuredDBServices()
    
    let fbServices = configuredFBServices()
    
    let interactors = configuredInteractors(appState, dbServices, fbServices)
    
    let container = Container(appState: appState, interactors: interactors)
    
    return AppEnvironment(container: container)
  }
}
