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
    
 
    static func apply(to window: UIWindow) {
        window.tintColor = UIColor.Theme.tint
    }
}
