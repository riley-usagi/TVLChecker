import SwiftUI

struct ContentView: View {
  
  @State private var searchText: String = ""
  
  @State private var receivedItems: [ItemModel] = []
  
  @State private var filteredItems: [ItemModel] = []
  
  var body: some View {
    
    NavigationStack {
      List {
        ForEach(filteredItems) { item in
          Text(item.indicator).font(.largeTitle)
        }
      }
      
      .listStyle(.plain)
      
      .navigationTitle("TVL Checker")
    }
    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    
    .onAppear {
      Task {
        self.receivedItems = try await ItemModel.receivedItems()
        self.filteredItems = self.receivedItems
      }
    }
    
    .onChange(of: searchText) { searchText in
      
      if !searchText.isEmpty {
        self.filteredItems = receivedItems.filter { $0.indicator.contains(searchText) }
      } else {
        self.filteredItems = receivedItems
      }
    }
  }
}
