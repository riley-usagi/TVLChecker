import SwiftUI

struct LoadingScreen: View {
  
  @Environment(\.container) var container: Container
  
  var body: some View {
    ZStack {
      ActivityIndicatorView()
    }
  }
}
