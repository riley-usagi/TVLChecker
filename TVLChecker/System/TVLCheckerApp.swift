import Firebase
import SwiftUI

@main struct TVLCheckerApp: App {
  
  let environment: AppEnvironment
  
  init() {
    FirebaseApp.configure()
    
    environment = AppEnvironment.bootstrap()
    
    environment.container.interactors.itemsInteractor.clearCoreData()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView(container: environment.container)
    }
  }
}
