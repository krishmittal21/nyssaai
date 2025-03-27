//
//  UIViewExtension.swift
//  nyssaai
//
//  Created by Krish Mittal on 27/03/25.
//

import SwiftUI

extension UIView {
    var tabController: UITabBarController? {
        if let controller = sequence(first: self, next: {
            $0.next
        }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        
        return nil
    }
}
