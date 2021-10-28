import Foundation

typealias HTTPCode  = Int
typealias HTTPCodes = Range<HTTPCode>

extension HTTPCodes {
  
  /// Диапазон допустимых кодов ответа от сервера
  static let success = 200 ..< 300
}
