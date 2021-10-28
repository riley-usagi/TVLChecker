import SwiftUI

struct DocumentScreen: View {
  
  let document: String
  
  init(_ document: String) {
    self.document = document
  }
  
  var body: some View {
    Text(document)
  }
}
