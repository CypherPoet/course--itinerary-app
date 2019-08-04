//
//  UIView+AddShadow.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/14/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


extension UIView {
    
    func addShadow(
        opacity: Float = 1.0,
        radius: CGFloat = 1.0,
        offset: CGSize = .zero,
        path: CGPath? = nil,
        color: CGColor
    ) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color
        layer.shadowPath = path
    }
}
