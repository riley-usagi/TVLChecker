import SwiftUI

struct ContentView: View {
  
  @State private var searchText: String = ""
  
  @State private var receivedItems: [ItemModel] = [
    ItemModel(indicator: "FirstIndicator", obj: "FirstObject", doc: "FirstDoc", val: "FirstVal"),
    ItemModel(indicator: "SecondIndicator", obj: "SecondObject", doc: "SecondDoc", val: "SecondVal")
  ]
  
  @State private var items: [ItemModel] = []
  
  var body: some View {
    
    NavigationStack {
      List {
        ForEach(items) { item in
          Text(item.indicator).font(.largeTitle)
        }
      }
      .listStyle(.plain)
      .navigationTitle("TVL Checker")
      
    }
    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    
    .onAppear {
      self.items = self.receivedItems
    }
    
    .onChange(of: searchText) { searchText in
      
      if !searchText.isEmpty {
        self.items = receivedItems.filter { $0.indicator.contains(searchText) }
      } else {
        self.items = receivedItems
      }
    }
  }
}
