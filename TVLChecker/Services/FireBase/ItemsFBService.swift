import Combine
import FirebaseFirestore

protocol ItemsFBService {
  func loadItems() -> AnyPublisher<[Item], Error>
}

struct RealItemsFBService: ItemsFBService {
  func loadItems() -> AnyPublisher<[Item], Error> {
    
    var items: [Item] = []
    
    return Future<[Item], Error> { promise in
      
      Firestore.firestore().collection("ingredients").getDocuments { (querySnapshot, error) in
        
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          promise(.failure(error!))
          return
        }
        
        items = documents.map { queryDocumentSnapshot -> Item in
          
          let data = queryDocumentSnapshot.data()
          
          let indicator = data["indicator"] as? String ?? ""
          let obj       = data["object"] as? String ?? ""
          let val       = data["value"] as? String ?? ""
          let doc       = data["document"] as? String ?? ""
          
          return Item(indicator: indicator, obj: obj, doc: doc, val: val)
        }
        
        promise(.success(items))
      }
      
    }.eraseToAnyPublisher()
  }
}
