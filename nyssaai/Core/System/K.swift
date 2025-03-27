//
//  K.swift
//  nyssaai
//
//  Created by Krish Mittal on 26/03/25.
//

import Foundation

struct K {
  static let view = "view"
  static let isLoggedIn = "isLoggedIn"
  static let isSigningUp = "isSigningUp"
  static let isAppFirstStart = "isAppFirstStart"
  static let userData = "userData"
}

extension Notification.Name {
  static let updateProfile = Notification.Name("updateProfile")
}
