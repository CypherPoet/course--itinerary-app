//
//  Style.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/15/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


/// This struct provides a mechanism for initialization with a closure that
/// takes a `UIView` and performs styling operations.
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
            view.addShadow(radius: 7, color: UIColor.Theme.accent2.cgColor)
            view.layer.cornerRadius = view.frame.width * 0.05
            view.backgroundColor = UIColor.Theme.background
        }
    }
    
    
    enum Label {
        static let largeTitle = UIViewStyle<UILabel> { label in
            label.font = UIFontMetrics(forTextStyle: .largeTitle)
                .scaledFont(for: UIFont.Custom.book.withSize(32))
        }
        
        static func largeBoldTitle(color: UIColor = .label) -> UIViewStyle<UILabel> {
            UIViewStyle<UILabel> { label in
                label.font = UIFontMetrics(forTextStyle: .largeTitle)
                    .scaledFont(for: UIFont.Custom.bold.withSize(32))
                label.textColor = color
            }
        }
        
        static func xLargeBoldTitle(color: UIColor = .label) -> UIViewStyle<UILabel> {
            UIViewStyle<UILabel> { label in
                label.font = UIFontMetrics(forTextStyle: .largeTitle)
                    .scaledFont(for: UIFont.Custom.bold.withSize(40))
                label.textColor = color
            }
        }
        
        
        static let subheadline = UIViewStyle<UILabel> { label in
            label.font = UIFontMetrics(forTextStyle: .subheadline)
                .scaledFont(for: UIFont.Custom.light.withSize(14))
        }
        
        
        static let formLabel = UIViewStyle<UILabel> { label in
            label.font = UIFontMetrics(forTextStyle: .subheadline)
                .scaledFont(for: UIFont.Custom.bold.withSize(14))
            label.textColor = UIColor.label
        }
    }
    
    
    enum Button {
        static let filledAction = UIViewStyle<UIButton> { button in
            button.layer.cornerRadius = Appearance.Constants.buttonCornerRadius
            button.clipsToBounds = true
            button.backgroundColor = UIColor.Theme.tint
            button.tintColor = UIColor.Theme.accent1
        }
        
        
        static func systemImage(named imageName: String) -> UIViewStyle<UIButton> {
            UIViewStyle<UIButton> { button in
                button.layer.cornerRadius = Appearance.Constants.buttonCornerRadius
                button.clipsToBounds = true
                button.backgroundColor = UIColor.systemGray4.withAlphaComponent(0.3)
                button.tintColor = UIColor.Theme.tint
                button.setImage(UIImage(systemName: imageName), for: .normal)
            }
        }
    }
    
    enum TextField {
        static func standard(color: UIColor = UIColor.label) -> UIViewStyle<UITextField> {
            UIViewStyle<UITextField> { textField in
                textField.textColor = color
                textField.font = UIFont.Custom.book
                textField.backgroundColor = .secondarySystemFill
            }
        }
        
        static func inset(color: UIColor = UIColor.label) -> UIViewStyle<UITextField> {
            TextField
                .standard()
                .withAdjustment { textField in
                    textField.layer.cornerRadius = 8
                    textField.clipsToBounds = true
                }
        }
    }
    
}
