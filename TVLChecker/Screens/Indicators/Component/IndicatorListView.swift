import SwiftUI

struct IndicatorListView: View {
  
  var indicator: String
  
  init(_ indicator: String) {
    self.indicator = indicator
  }
  
  var body: some View {
    
    HStack(spacing: 15) {
      
      VStack(alignment: .leading, spacing: 8) {
        
        Text(indicator)
          .fontWeight(.bold)
        
//        Text(item["detail"] ?? "Some name")
//          .font(.caption)
//          .foregroundColor(.gray)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Button {
        
      } label: {
        Image(systemName: "arrow.forward.circle.fill")
          .foregroundColor(.yellow)
          .padding()
          .background(
            Color(
              #colorLiteral(red: 0.8623041511, green: 0.9054111242, blue: 0.4528588057, alpha: 1)
            ).opacity(0.2)
          )
          .clipShape(Circle())
      }
      
    }
    .padding(.horizontal, 15)
  }
}
