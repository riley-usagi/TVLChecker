import AiDesign
import SwiftUI

/// Компонент с отображением информации о документе выбранного показателя
struct DocComponent: View {
  
  
  // MARK: - Parameters
  
  /// Выбранный показатель
  @Binding var selectedItem: ItemModel
  
  
  // MARK: - Initializers
  
  init(_ selectedItem: Binding<ItemModel>) {
    self._selectedItem = selectedItem
  }
  
  
  // MARK: - Body
  
  var body: some View {
    HStack {
      Text(selectedItem.doc)
    }
    .typography(.h2Bold, .aiBlack80)
  }
}
