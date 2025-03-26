//
//  AppState.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import SwiftUI

class AppState: ObservableObject {
  enum CurrentView: Int {
    case nonAuthenticated
    case authenticated
  }
  
  @Published var switchView: CurrentView = .nonAuthenticated {
    didSet {
      UserDefaults.standard.set(switchView.rawValue, forKey: K.view)
    }
  }
  
  init() {
    if let savedRawValue = UserDefaults.standard.object(forKey: K.view) as? Int,
       let savedView = CurrentView(rawValue: savedRawValue) {
      switchView = savedView
    }
    
    Task { @MainActor in
      if let userId = UserDefaults.standard.string(forKey: "userId") {
        GlobalVariables.shared.userId = userId
      }
      
      if let userData = UserDefaults.standard.data(forKey: "currentUser"),
         let user = try? JSONDecoder().decode(NSUser.self, from: userData) {
        GlobalVariables.shared.currentUser = user
      }
    }
  }
}
