import Combine
import CoreData

extension NSManagedObjectContext {
  
  /// Адаптация Контекста только на чтение
  func configureAsReadOnlyContext() {
    automaticallyMergesChangesFromParent  = true
    mergePolicy                           = NSRollbackMergePolicy
    undoManager                           = nil
    shouldDeleteInaccessibleFaults        = false
  }

  /// Адаптация Контекста на обновление данных
  func configureAsUpdateContext() {
    mergePolicy = NSOverwriteMergePolicy
    undoManager = nil
  }
}
