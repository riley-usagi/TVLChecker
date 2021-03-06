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
  
  @FocusState private var searchFieldIsFocused: Bool
  
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
    case let .loaded(items):
      return AnyView(loadedView(items))
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


// MARK: - Loaded view

private extension ItemsScreen {
  func loadedView(_ items: LazyList<Item>) -> some View {
    ZStack(alignment: .top) {
      
      VStack {
        
        if searchQuery == "" {
          
          HStack {
            
            Spacer()
            
            Button {
              
            } label: {
              Image(systemName: "questionmark.circle")
                .font(.title2)
                .foregroundColor(.primary)
            }
          }
          .padding()
          
          HStack {
            
            Group {
              Text("Список ")
                .fontWeight(.bold)
              
              +
              
              Text("показателей")
                .foregroundColor(.gray)
              
            }
            .font(.largeTitle)
            .overlay(
              
              GeometryReader { reader -> Color in
                
                let width = reader.frame(in: .global).maxX
                
                DispatchQueue.main.async {
                  
                  if titleOffset == 0 {
                    titleOffset = width
                  }
                }
                
                return .clear
              }.frame(width: 0, height: 0)
            )
            .padding()
            .scaleEffect(getScale())
            .offset(getOffset())
            
            Spacer()
          }
          
        }
        
        VStack {
          
          HStack(spacing: 15) {
            
            Image(systemName: "magnifyingglass")
              .font(.system(size: 23, weight: .bold))
              .foregroundColor(.gray)
            
            TextField("Поиск", text: $searchQuery)
              .focused($searchFieldIsFocused)
              .onChange(of: searchQuery) { newValue in
                container.interactors.itemsInteractor.loadItems($items, newValue)
              }
          }
          .padding(.vertical, 10)
          .padding(.horizontal)
          .background(Color.primary.opacity(0.05))
          .cornerRadius(8)
          .padding(.horizontal)
          
          if searchQuery == "" {
            
            HStack {
              
              Text("НЕДАВНИЕ")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
              
              Rectangle()
                .fill(Color.gray.opacity(0.6))
                .frame(height: 0.5)
            }
            .padding()
            
          }
          
        }
        .offset(y: offset > 0 && searchQuery == "" ? (offset <= 95 ? -offset : -95) : 0)
      }
      .zIndex(1)
      .padding(.bottom, searchQuery == "" ? getOffset().height : 0)
      .background(
        
        ZStack {
          
          let color = colorScheme == .dark ? Color.black : Color.white
          
          LinearGradient(
            gradient: .init(colors: [color, color, color, color.opacity(0.6)]),
            startPoint: .top,
            endPoint: .bottom
          )
        }.ignoresSafeArea()
          .onTapGesture {
            searchFieldIsFocused = false
          }
        
      )
      .overlay(
        
        GeometryReader { reader -> Color in
          
          let height = reader.frame(in: .global).maxY
          
          DispatchQueue.main.async {
            if titleBarHeight == 0 {
              titleBarHeight = height - (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
            }
          }
          
          return .clear
        }
        
        
      )
      .animation(.easeInOut, value: searchQuery != "")
      
      ScrollView(.vertical, showsIndicators: false) {
        
        VStack(spacing: 15) {
          
          ForEach(items) { item in
            ItemsListView(item)
          }
        }
        .padding(.top, 10)
        .padding(.top, searchQuery == "" ? titleBarHeight : 90)
        .overlay(
          
          GeometryReader { reader -> Color in
            
            let minY = reader.frame(in: .global).minY
            
            DispatchQueue.main.async {
              
              if startOffset == 0 {
                startOffset = minY
              }
              
              offset = startOffset - minY
            }
            
            return .clear
          }
        )
      }
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
