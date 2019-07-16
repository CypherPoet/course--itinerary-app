//
//  Style.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


/// This struct provides a mechanism for initialization with a closure that
/// takes the `UIView` and performs styling operations.
struct UIViewStyle<T: UIView> {
    let styling: (T) -> Void
    
    
    func apply(to view: T) {
        styling(view)
    }
    
    
    func apply(to views: T...) {
        views.forEach { apply(to: $0) }
    }
    
    
    func withAdjustment(_ adjustment: @escaping (T) -> Void) -> UIViewStyle<T> {
        let styling = self.styling
        
        return UIViewStyle { view in
            styling(view)
            adjustment(view)
        }
    }
}


enum Style {
    
    enum TripCard {
        static let standard = UIViewStyle<UIView> { view in
            view.addShadow(radius: 10, color: UIColor.tertiaryLabel.cgColor)
            view.layer.cornerRadius = view.frame.width * 0.05
            view.backgroundColor = UIColor.Theme.background
        }
    }
    
    
    enum Label {
        static let largeTitle = UIViewStyle<UILabel> { label in
            label.font = UIFontMetrics(forTextStyle: .largeTitle)
                .scaledFont(for: UIFont.Custom.book.withSize(32))
        }
        
        static let largeBoldTitle = UIViewStyle<UILabel> { label in
            label.font = UIFontMetrics(forTextStyle: .largeTitle)
                .scaledFont(for: UIFont.Custom.bold.withSize(32))
        }
        
        
        static let subheadline = UIViewStyle<UILabel> { label in
            label.font = UIFontMetrics(forTextStyle: .subheadline)
                .scaledFont(for: UIFont.Custom.light.withSize(14))
        }
    }
}
