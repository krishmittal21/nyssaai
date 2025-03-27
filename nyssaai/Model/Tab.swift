//
//  Tab.swift
//  nyssaai
//
//  Created by Krish Mittal on 27/03/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
  case home = "house.fill"
  case assistant = "person.2.fill"
  case settings = "gearshape"
  
  var title: String {
    switch self {
    case .home:
      "Home"
    case .assistant:
      "Tools"
    case .settings:
      "Settings"
    }
  }
}
