import CoreData
import Foundation

@objc(ItemModelObject) public class ItemModelObject: NSManagedObject {}

extension ItemModelObject {
  
  static func justOneItem() -> NSFetchRequest<ItemModelObject> {
    
    let request = newFetchRequest()
    
    request.fetchLimit = 1
    
    return request
  }
  
  static func itemsList(searchText: String) -> NSFetchRequest<ItemModelObject> {
    
    let request = newFetchRequest()
    
    if searchText.count == 0 {
      request.predicate = NSPredicate(value: true)
    } else {
      
      let titlePredicate = NSPredicate(
        format: "indicator CONTAINS[cd] %@",
        searchText
      )
      
      request.predicate = titlePredicate
    }
    
    request.sortDescriptors = [NSSortDescriptor(key: "indicator", ascending: true)]
    request.fetchBatchSize = 10
    
    return request
  }
}
