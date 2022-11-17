import Foundation

struct ItemModel: Identifiable, Equatable {
  var id: UUID = UUID()
  var indicator: String
  var obj: String
  var doc: String
  var val: String
}
