//
//  HideTabBar.swift
//  nyssaai
//
//  Created by Krish Mittal on 27/03/25.
//

import SwiftUI

struct HideTabBar: UIViewRepresentable {
  init(result: @escaping () -> Void) {
    UITabBar.appearance().isHidden = true
    self.result = result
  }
  
  var result: () -> ()
  
  func makeUIView(context: Context) -> UIView {
    let view = UIView(frame: .zero)
    view.backgroundColor = .clear
    
    DispatchQueue.main.async {
      if let tabController = view.tabController {
        UITabBar.appearance().isHidden = false
        tabController.tabBar.isHidden = true
        result()
      }
    }
    
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) { }
}
