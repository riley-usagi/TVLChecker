import CoreData
import Foundation

extension ItemModelObject {
  
  @NSManaged public var id: String?
  @NSManaged public var indicator: String?
  @NSManaged public var obj: String?
  @NSManaged public var doc: String?
  @NSManaged public var val: String?
  
}

extension ItemModelObject: Identifiable {}
extension ItemModelObject: ManagedEntity {}
