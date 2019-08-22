//
//  Appearance.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


enum Appearance {
    
    enum Constants {
        static let modalCornerRadius: CGFloat = 14
        static let buttonCornerRadius: CGFloat = 8
        static let wideButtonCornerRadius: CGFloat = 14
    }
    
    enum Navbar {
        static let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.Theme.accent1,
            .font: UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.Custom.bold.withSize(22))
        ]
    }
    
 
    static func apply(to window: UIWindow) {
        window.tintColor = UIColor.Theme.tint
    }
    
    
    static func apply(to navbar: UINavigationBar) {
        let appearance = UINavigationBarAppearance()
        
        appearance.backgroundColor = UIColor.Theme.background
        appearance.titleTextAttributes.merge(
            Navbar.titleTextAttributes,
            uniquingKeysWith: { (_, newKey) -> Any in newKey }
        )
        
        navbar.standardAppearance = appearance
        navbar.compactAppearance = appearance
        navbar.scrollEdgeAppearance = appearance
        navbar.scrollEdgeAppearance?.configureWithTransparentBackground()
        
        navbar.isTranslucent = true
    }
}
