import SwiftUI

struct IndicatorsScreen: View {
  
  @State private var searchQuery: String = ""
  
  var items: [[String: String]] = [
    ["name": "Нефтепродукты", "detail": "Питьевая воды"]
  ]
  
  var body: some View {
    
    VStack {
      VStack {
        
//        HStack {
//
//          Button {
//
//          } label: {
//            Image(systemName: "star")
//              .font(.title2)
//              .foregroundColor(.primary)
//          }
//
//          Spacer()
//
//          Button {
//
//          } label: {
//            Image(systemName: "plus")
//              .font(.title2)
//              .foregroundColor(.primary)
//          }
//        }
//        .padding()
        
        HStack {
          
          Group {
            Text("Список ")
              .fontWeight(.bold)
            
            +
            
            Text("показателей")
              .foregroundColor(.gray)
            
          }
          .font(.largeTitle)
          
          Spacer()
        }
        .padding()
        
        HStack(spacing: 15) {
          
          Image(systemName: "magnifyingglass")
            .font(.system(size: 23, weight: .bold))
            .foregroundColor(.gray)
          
          TextField("Поиск", text: $searchQuery)
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.primary.opacity(0.05))
        .cornerRadius(8)
        .padding(.horizontal)
        
        HStack {
          
          Text("НЕДАВНИЕ")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.gray)
          
          Rectangle()
            .fill(Color.gray.opacity(0.6))
            .frame(height: 0.5)
        }
        .padding()
      }
      
      ScrollView(.vertical, showsIndicators: false) {
        
        VStack(spacing: 15) {
          
          ForEach(items, id: \.self) { item in
            IndicatorItemView(item: item)
          }
        }
      }
    }
  }
}
