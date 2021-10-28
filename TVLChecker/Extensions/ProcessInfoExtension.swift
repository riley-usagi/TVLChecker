import SwiftUI

extension ProcessInfo {
  
  /// Проверка статуса тестирования
  var isRunningTests: Bool {
    environment["XCTestConfigurationFilePath"] != nil
  }
}
