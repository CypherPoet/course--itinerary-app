//
//  FilledActionButton.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/14/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class FilledActionButton: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupStyles()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}


private extension FilledActionButton {
    
    func setupStyles() {
        Style.Button.filledAction.apply(to: self)
    }
}
