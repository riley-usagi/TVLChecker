import Firebase
import SwiftUI

@main struct TVLCheckerApp: App {
  
  let environment: AppEnvironment
  
  init() {
    FirebaseApp.configure()
    
    environment = AppEnvironment.bootstrap()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView(container: environment.container)
    }
  }
}
