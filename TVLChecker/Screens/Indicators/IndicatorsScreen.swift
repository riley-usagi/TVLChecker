import SwiftUI

struct IndicatorsScreen: View {
  
  @State private var searchQuery: String = ""
  
  @State private var offset: CGFloat      = 0
  @State private var startOffset: CGFloat = 0
  @State private var titleOffset: CGFloat = 0
  
  var items: [[String: String]] = [
    ["name": "Нефтепродукты", "detail": "Питьевая воды"]
  ]
  
  var body: some View {
    
    VStack {
      VStack {
        
        HStack {
          
//          Button {
//
//          } label: {
//            Image(systemName: "star")
//              .font(.title2)
//              .foregroundColor(.primary)
//          }
          
          Spacer()
          
          Button {
            
          } label: {
            Image(systemName: "questionmark.circle")
              .font(.title2)
              .foregroundColor(.primary)
          }
        }
        .padding()
        
        HStack {
          
          Group {
            Text("Список ")
              .fontWeight(.bold)
            
            +
            
            Text("показателей")
              .foregroundColor(.gray)
            
          }
          .font(.largeTitle)
          .overlay(
            
            GeometryReader { reader -> Color in
              
              let width = reader.frame(in: .global).maxX
              
              DispatchQueue.main.async {
                
                if titleOffset == 0 {
                  titleOffset = width
                }
              }
              
              return .clear
            }.frame(width: 0, height: 0)
          )
          .padding()
          .offset(getOffset())
          
          Spacer()
        }
        
        
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
        .padding(.top, 10)
        .overlay(
          
          GeometryReader { reader -> Color in
            
            let minY = reader.frame(in: .global).minY
            
            DispatchQueue.main.async {
              
              if startOffset == 0 {
                startOffset = minY
              }
              
              offset = startOffset - minY
              
              print(offset)
            }
            
            return .clear
          }
        )
      }
    }
  }
  
  private func getOffset() -> CGSize {
    
    let screenWidth = UIScreen.main.bounds.width / 2
    
    var size: CGSize = .zero
    
    size.width  = offset > 0 ? (offset * 1.5 <= (screenWidth - titleOffset) ? offset * 1.5 : (screenWidth - titleOffset)) : 0
    size.height = offset > 0 ? (offset <= 75 ? -offset : -75) : 0
    
    return size
  }
}
