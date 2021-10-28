import CoreData
import SwiftUI

/// Объект модели - Item
struct Item: Identifiable, Equatable {
  
  
  // MARK: - Variables
  
  var id: String = UUID().uuidString
  var indicator: String
  var obj: String
  var doc: String
  var val: String
}


extension Item {
  
  init?(managedObject: ItemModelObject) {
    
    self.init(
      indicator: managedObject.indicator ?? "",
      obj: managedObject.obj ?? "",
      doc: managedObject.doc ?? "",
      val: managedObject.val ?? ""
    )
  }
  
  @discardableResult
  func modelToObjectWithin(_ context: NSManagedObjectContext) -> ItemModelObject? {
    guard let item = ItemModelObject.insertNew(in: context) else { return nil }
    
    item.indicator = indicator
    item.doc = doc
    item.val = val
    item.obj = obj
    
    return item
  }
}
