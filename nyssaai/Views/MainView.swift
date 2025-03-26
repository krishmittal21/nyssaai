//
//  MainView.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import SwiftUI

struct MainView: View {
  @EnvironmentObject var appState: AppState
  @State private var showMenu: Bool = false
  
  var body: some View {
    Sidebar(showMenu: $showMenu) { safeArea in
      NavigationStack {
        VStack {
          Text("Global variable userid: \(GlobalVariables.shared.userId ?? "")")
          Button {
            appState.switchView = .nonAuthenticated
          } label: {
            Text("Log out")
          }
        }
        .navigationTitle("Chat App")
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              showMenu.toggle()
            } label: {
              Image(systemName: "line.3.horizontal")
            }
          }
        }
      }
    } menuView: { safeArea in
      VStack(alignment: .leading, spacing: 20) {
        Text("Menu")
          .font(.title.bold())
        
        Button {
          appState.switchView = .nonAuthenticated
        } label: {
          Label("Log out", systemImage: "rectangle.portrait.and.arrow.right")
        }
        
        Spacer()
      }
      .padding(.horizontal, 15)
      .padding(.vertical, 20)
      .padding(.top, safeArea.top)
      .padding(.bottom, safeArea.bottom)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
  }
}

#Preview {
  MainView()
}
