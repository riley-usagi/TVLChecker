import SwiftUI

struct ContentView: View {
  
  @State private var searchText: String = ""
  
  @State private var receivedItems: [ItemModel] = []
  
  @State private var filteredItems: [ItemModel] = []
  
  @State private var selectedItem: ItemModel    = ItemModel.stub
  
  @State private var sheetStatus: Bool          = false
  
  var body: some View {
    
    NavigationStack {
      List {
        ForEach(filteredItems) { item in
          HStack {
            Text(item.indicator).font(.title)
            Spacer()
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
        .presentationDetents([.fraction(0.5)])
    }
    
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
