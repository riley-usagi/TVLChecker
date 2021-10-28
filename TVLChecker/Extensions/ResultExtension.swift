extension Result {
  
  /// Простая обёртка для Result
  var isSuccess: Bool {
    switch self {
    case .success: return true
    case .failure: return false
    }
  }
}
