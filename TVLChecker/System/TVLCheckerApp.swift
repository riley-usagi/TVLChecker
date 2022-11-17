import Firebase
import SwiftUI

/// Точка входа в приложение
@main struct TVLCheckerApp: App {
  
  
  // MARK: - Initializers
  
  init() {
    FirebaseApp.configure()
  }
  
  
  // MARK: - Body
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
