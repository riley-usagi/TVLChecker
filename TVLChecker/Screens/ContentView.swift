import AiDesign
import SwiftUI

/// Главный экран
struct ContentView: View {
  
  /// Поисковый запрос
  @State private var searchText: String         = ""
  
  /// Список полученных показателей
  @State private var receivedItems: [ItemModel] = []
  
  /// Отфильтрованные при помощи поиска результаты
  @State private var filteredItems: [ItemModel] = []
  
  /// Выбранный показатель для всплывашки
  @State private var selectedItem: ItemModel    = ItemModel.stub
  
  /// Статус отображения всплывашки
  @State private var sheetStatus: Bool          = false
  
  var body: some View {
    
    NavigationStack {
      
      List {
        
        ForEach(filteredItems) { item in
          
          HStack {
            
            VStack {
              HStack {
                Text(item.indicator)
                  .typography(.h2Bold, .aiBlack)
                Spacer()
              }
              
              HStack {
                Text(item.obj.capitalized)
                  .typography(.h3Regular, .aiCyan60)
                Spacer()
              }
            }
            
            Spacer()
            
            Text(item.val)
              .typography(.h3Regular, .aiPurple80)
          }
          
          .contentShape(Rectangle())
          
          .onTapGesture {
            self.selectedItem = item
            self.sheetStatus.toggle()
          }
        }
      }
      
      .listStyle(.plain)
      
      .navigationTitle("TVL Checker")
      
    }
    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    
    .sheet(isPresented: $sheetStatus) {
      DocComponent($selectedItem)
        .presentationDetents([.fraction(0.3)])
    }
    
    .onAppear {
      Task {
        self.receivedItems = try await ItemModel.receivedItems()
        self.filteredItems = self.receivedItems
      }
    }
    
    .onChange(of: searchText) { searchText in
      
      if !searchText.isEmpty {
        self.filteredItems =
        receivedItems
          .filter { $0.indicator.contains(searchText) }
          .sorted { $0.indicator < $1.indicator }
      } else {
        self.filteredItems = receivedItems
      }
    }
  }
}
