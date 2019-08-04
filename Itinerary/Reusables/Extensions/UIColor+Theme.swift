//
//  UIColor+Theme.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


extension UIColor {
    enum Theme {
        static let background = color(named: "Background")
        static let tint = color(named: "Tint")
        static let accent1 = color(named: "Accent 1")
        static let accent2 = color(named: "Accent 2")
        static let accent3 = color(named: "Accent 3")
    }
    
    
    private static func color(named name: String) -> UIColor {
        UIColor(named: name) ?? .systemPurple
    }
}
