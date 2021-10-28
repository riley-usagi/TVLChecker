import SwiftUI

struct ItemsListView: View {
  var item: Item
  
  @State private var showDocumentSheet: Bool = false
  
  init(_ item: Item) {
    self.item = item
  }
  
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 15) {
        
        VStack(alignment: .leading, spacing: 8) {
          
          Text(item.indicator)
            .fontWeight(.bold)
          
          Text(item.obj)
            .font(.caption)
            .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Text(item.val)
      }
      .padding(.horizontal, 15)
      
      Divider()
        .padding()
    }
    .onTapGesture {
      showDocumentSheet.toggle()
    }
    .sheet(isPresented: $showDocumentSheet) {
      DocumentScreen(item.doc)
    }
  }
}
