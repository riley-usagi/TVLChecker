// MARK: - FireBase services
extension AppEnvironment {
  
  /// Обрабатываем и возвращаем список всех репозиториев для работы с FireBase
  /// - Parameter appState: Объект хранилища данных
  /// - Returns: Список настроенных FireBase-репозиториев
  static func configuredFBServices() -> Container.FBServices {
    
    let itemsFBService = RealItemsFBService()

    return .init(itemsFBService)
  }
}
