import FirebaseFirestore

/// Элемент базы данных
struct ItemModel: Identifiable, Equatable {
  
  
  // MARK: - Parameters
  
  /// Уникальный ID
  var id: UUID = UUID()
  
  /// Индикатор
  var indicator: String
  
  /// Объект
  var obj: String
  
  /// Правовой документ
  var doc: String
  
  /// Допустимое значение
  var val: String
}


// MARK: - Methods

extension ItemModel {
  
  /// Асинхронный процесс получения данных о показателях из FireStore
  /// - Returns: Список показателей
  static func receivedItems() async throws -> [ItemModel] {
    
    do {
      
      let firestoreDatabase = Firestore.firestore()
      
      var itemsToCollect: [ItemModel] = []
      
      let snapshot = try await firestoreDatabase.collection("ingredients").getDocuments()
      
      snapshot.documents.forEach { documentSnapshot in
        
        let receivedData = documentSnapshot.data()
        
        let indicator = receivedData["indicator"] as? String ?? ""
        let obj       = receivedData["object"] as? String ?? ""
        let doc       = receivedData["document"] as? String ?? ""
        let val       = receivedData["value"] as? String ?? ""
        
        itemsToCollect.append(
          ItemModel(indicator: indicator, obj: obj, doc: doc, val: val)
        )
      }
      
      return itemsToCollect.sorted { $0.indicator < $1.indicator }
      
    } catch {
      throw FireBaseError.badApiRequest
    }
  }
}


// MARK: - Stubs

extension ItemModel {
  
  /// Заглушка
  static var stub: ItemModel = ItemModel(
    indicator: "stub", obj: "stub", doc: "stub", val: "stub"
  )
}
