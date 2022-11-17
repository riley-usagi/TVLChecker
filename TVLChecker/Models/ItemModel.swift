import FirebaseFirestore
import Foundation

struct ItemModel: Identifiable, Equatable {
  var id: UUID = UUID()
  var indicator: String
  var obj: String
  var doc: String
  var val: String
}

extension ItemModel {
  
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
      
      return itemsToCollect
    } catch {
      throw FireBaseError.badApiRequest
    }
  }
}

extension ItemModel {
  static var stub: ItemModel = ItemModel(
    indicator: "stub", obj: "stub", doc: "stub", val: "stub"
  )
}
