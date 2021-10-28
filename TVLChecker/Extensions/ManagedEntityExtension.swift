import Combine
import CoreData

protocol ManagedEntity: NSFetchRequestResult {}

extension ManagedEntity where Self: NSManagedObject {
  
  /// Название таблицы
  static var entityName: String {
    return String(describing: Self.self)
  }
  
  /// Метод добавления данных в Контекст базы данных
  /// - Parameter context: Объект контекста
  /// - Returns: NSManagedObject - запись таблицы
  static func insertNew(in context: NSManagedObjectContext) -> Self? {
    return NSEntityDescription
      .insertNewObject(forEntityName: entityName, into: context) as? Self
  }
  
  /// Объект базового запроса к базе данных
  /// - Returns: Объект базового запроса к базе данных
  static func newFetchRequest() -> NSFetchRequest<Self> {
    return .init(entityName: entityName)
  }
}
