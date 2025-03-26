//
//  nyssaaiApp.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    return true
  }
}

@main
struct nyssaaiApp: App {
  @StateObject private var appState = AppState()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      ViewManager()
        .environmentObject(appState)
        .preferredColorScheme(.light)
    }
  }
}
