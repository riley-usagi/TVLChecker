import SwiftUI

struct ContentView: View {
  
  private let container: Container
  
  init(container: Container) {
    self.container = container
  }
  
  var body: some View {
    
    ItemsScreen()
      .inject(container)
  }
}
