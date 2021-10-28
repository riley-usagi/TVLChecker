import SwiftUI

/// Контейнер с зависимостями приложения
struct Container: EnvironmentKey {
  
  
  // MARK: - Технические параметры
  
  static var defaultValue: Self { Self.default }
  
  private static let `default` = Self(appState: AppState(), interactors: .stub)
  
  
  // MARK: - Параметры
  
  /// Локальное динамческое хранилище
  let appState: Store<AppState>
  
  /// Список интеракторов
  let interactors: Interactors
  
  // MARK: - Инициализаторы
  init(appState: Store<AppState>, interactors: Interactors) {
    self.appState     = appState
    self.interactors  = interactors
  }
  
  init(appState: AppState, interactors: Interactors) {
    self.init(appState: Store<AppState>(appState), interactors: interactors)
  }
}


extension EnvironmentValues {
  
  var container: Container {
    get { self[Container.self] }
    set { self[Container.self] = newValue }
  }
}
