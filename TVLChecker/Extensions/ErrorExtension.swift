import Foundation

extension Error {
  
  var underlyingError: Error? {
    
    let nsError = self as NSError
    
    // В случае проблем с интернетом
    if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
      return self
    }
    
    return nsError.userInfo[NSUnderlyingErrorKey] as? Error
  }
}
