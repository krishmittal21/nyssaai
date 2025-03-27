//
//  TabBarContainerView.swift
//  nyssaai
//
//  Created by Krish Mittal on 27/03/25.
//

import SwiftUI

struct TabBarContainerView: View {
  @Binding var activeTab: Tab
  @Binding var isTabbarHidden: Bool
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Group {
        if #available(iOS 18, *) {
          TabView(selection: $activeTab) {
            SwiftUI.Tab.init(value: .home) {
              HomeView()
                .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            SwiftUI.Tab.init(value: .assistant) {
              Text("Assistant")
                .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            SwiftUI.Tab.init(value: .settings) {
              Text("settings")
                .toolbarVisibility(.hidden, for: .tabBar)
            }
          }
        } else {
          TabView(selection: $activeTab) {
            HomeView()
              .tag(Tab.home)
              .background {
                if !isTabbarHidden {
                  HideTabBar {
                    isTabbarHidden = true
                  }
                }
              }
            
            Text("Assistant")
              .tag(Tab.assistant)
              .background {
                if !isTabbarHidden {
                  HideTabBar {
                    isTabbarHidden = true
                  }
                }
              }
            
            Text("Chat History")
              .tag(Tab.settings)
              .background {
                if !isTabbarHidden {
                  HideTabBar {
                    isTabbarHidden = true
                  }
                }
              }
          }
        }
      }
      
      CustomTabBar(activeTab: $activeTab)
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
  }
}
