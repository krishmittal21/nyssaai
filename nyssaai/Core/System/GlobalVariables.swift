//
//  GlobalVariables.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import Foundation

@Observable
@MainActor
class GlobalVariables {
  static var shared = GlobalVariables()
  
  class func reintiate(){
    Task { @MainActor in
      GlobalVariables.shared = GlobalVariables()
    }
  }
  
  static var appState = AppState()
    
  var userId: String = ""
  
  var currentUser: NSUser? = UserDefaults().codableObject(dataType: NSUser.self, key: K.userData) {
    didSet {
      if let user = currentUser {
        UserDefaults().setCodableObject(user, forKey: K.userData)
      }
    }
  }
}

extension UserDefaults {
  func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
    let encoded = try? JSONEncoder().encode(data)
    set(encoded, forKey: defaultName)
  }
  
  func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
    guard let userDefaultData = data(forKey: key) else {
      return nil
    }
    return try? JSONDecoder().decode(T.self, from: userDefaultData)
  }
}

extension UserDefaults {
  static func resetDefaults() {
    if let bundleID = Bundle.main.bundleIdentifier {
      UserDefaults.standard.removePersistentDomain(forName: bundleID)
    }
  }
}
