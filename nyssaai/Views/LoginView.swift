//
//  LoginView.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
  @EnvironmentObject var appState: AppState
  @State private var authentication = Authentication()
  
  var body: some View {
    VStack {
      SignInWithAppleButton { request in
        authentication.handleSignInWithAppleRequest(request)
      } onCompletion: { result in
        authentication.handleSignInWithAppleCompletion(result)
        if authentication.isSignedIn {
          appState.switchView = .authenticated
        }
      }
      .frame(height: 44)
      .padding(.horizontal, 50)
      .padding(.bottom, 50)
    }
    .ignoresSafeArea()
    .background(.ultraThinMaterial)

  }
}

#Preview {
  LoginView()
}
