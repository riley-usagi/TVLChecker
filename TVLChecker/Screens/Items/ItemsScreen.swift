import SwiftUI

struct ItemsScreen: View {
  
  @Environment(\.colorScheme) var colorScheme
  
  @Environment(\.container) private var container: Container
  
  @State private var items: Loadable<LazyList<Item>>
  
  @State private var searchQuery: String = ""
  
  @State private var offset: CGFloat          = 0
  @State private var startOffset: CGFloat     = 0
  @State private var titleOffset: CGFloat     = 0
  @State private var titleBarHeight: CGFloat  = 0
  
  init(items: Loadable<LazyList<Item>> = .notRequested) {
    self._items = .init(initialValue: items)
  }
  
  var body: some View {
    content
  }
}


// MARK: - Content

extension ItemsScreen {
  var content: some View {
    switch items {
      
    case .notRequested:
      return AnyView(notRequestedView)
    case .isLoading:
      return AnyView(ActivityIndicatorView())
    case .loaded:
      return AnyView(Text("Loaded"))
    case .failed:
      return AnyView(Text("Failed"))
    }
  }
}


// MARK: - Not Requested view

private extension ItemsScreen {
  var notRequestedView: some View {
    Text("")
      .onAppear {
        container.interactors.itemsInteractor.loadItems($items, searchQuery)
      }
  }
}

// MARK: - Helpers

extension ItemsScreen {
  private func getOffset() -> CGSize {
    
    let screenWidth = UIScreen.main.bounds.width / 2
    
    var size: CGSize = .zero
    
    size.width  = offset > 0 ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
    size.height = offset > 0 ? (offset <= 75 ? -offset : -75) : 0
    
    return size
  }
  
  private func getScale() -> CGFloat {
    if offset > 0 {
      let screenWidth = UIScreen.main.bounds.width
      
      let progress = 1 - (getOffset().width / screenWidth)
      
      return progress >= 0.7 ? progress: 0.7
    } else {
      return 1
    }
  }
}
