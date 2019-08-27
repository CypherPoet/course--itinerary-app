//
//  IntroView.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol IntroViewDelegate: class {
    func viewDidFinishAnimation(_ view: IntroView)
}



class IntroView: UIView {
    @IBOutlet private var iconImageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


extension IntroView {
    
    func animate(then completionHandler: ((Bool) -> Void)?) {
        UIView.animate(
            withDuration: 0.65,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.iconImageView.alpha = 0.0
                self.iconImageView.transform = CGAffineTransform.identity
                    .rotated(by: (.pi / 180) * 120)
                    .scaledBy(x: 3, y: 3)
            },
            completion: { didComplete in
                completionHandler?(didComplete)
            }
        )
    }
}
