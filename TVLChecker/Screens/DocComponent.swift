import SwiftUI

struct DocComponent: View {
  
  @Binding var selectedItem: ItemModel
  
  init(_ selectedItem: Binding<ItemModel>) {
    self._selectedItem = selectedItem
  }
  
  var body: some View {
    Text(selectedItem.doc)
      .font(.title)
  }
}
