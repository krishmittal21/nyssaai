//
//  ViewManager.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import SwiftUI

struct ViewManager: View {
  @EnvironmentObject var appState: AppState
  @State private var previousView: AppState.CurrentView = .nonAuthenticated
  @State private var activeTab: Tab = .home
  @State private var isTabbarHidden: Bool = false
  
  var body: some View {
    Group {
      switch (appState.switchView) {
      case .nonAuthenticated:
        LoginView()
        
      case .authenticated:
        TabBarContainerView(activeTab: $activeTab, isTabbarHidden: $isTabbarHidden)
          .transition(.move(edge: .trailing).combined(with: .opacity))
      }
    }
    .animation(shouldAnimate() ? .easeInOut : .none, value: appState.switchView)
    .onChange(of: appState.switchView) { _, newValue in
      previousView = newValue
    }
  }
  
  private func shouldAnimate() -> Bool {
    return previousView == .nonAuthenticated && appState.switchView == .authenticated
  }
}
