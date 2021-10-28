import SwiftUI

extension View {
  
  /// Внедрение объекта Container в иерархию View
  /// - Parameters:
  ///   - appState: AppState
  ///   - interactors: Список интеракторов
  /// - Returns: Объект View для внедрения в иерархию
  func inject(_ appState: AppState, _ interactors: Container.Interactors) -> some View {
    let container = Container(appState: .init(appState), interactors: interactors)
    
    return inject(container)
  }
  
  
  /// Добавление главного контейнера в иерархию Экранов
  /// - Parameter container: Объект настроенного контейнера
  /// - Returns: Объект View
  func inject(_ container: Container) -> some View {
    return self
      .environment(\.container, container)
  }
}

extension View {
  /// Плейсхолдер (заглушка) для текстовых полей
  /// - Parameters:
  ///   - shouldShow: Показывать или нет
  ///   - alignment: Центрирование
  ///   - placeholder: Текст заглушки
  /// - Returns: Объект View c плейсхолдером
  func placeholder<Content: View>(
    when shouldShow: Bool,
    alignment: Alignment = .leading,
    @ViewBuilder placeholder: () -> Content) -> some View {
      
      ZStack(alignment: alignment) {
        placeholder().opacity(shouldShow ? 1 : 0)
        self
      }
    }
}
