import Combine
import Foundation

/// Общая функциональность всех web-сервисов
protocol WebService {
  
  var session: URLSession { get }
  
  var baseURL: String { get }
  
  var bgQueue: DispatchQueue { get }
}


extension WebService {
  
  func call<Value>(endpoint: APICall, httpCodes: HTTPCodes = .success)
  -> AnyPublisher<Value, Error> where Value: Decodable {
    
    do {
      
      let request = try endpoint.urlRequest(baseUrl: baseURL)
      
      return session
        .dataTaskPublisher(for: request)
        .requestJSON(httpCodes: httpCodes)
      
    } catch let error {
      return Fail<Value, Error>(error: error).eraseToAnyPublisher()
    }
  }
}
