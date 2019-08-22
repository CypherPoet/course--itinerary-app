//
//  SectionBackgroundDecoration.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/20/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class SectionBackgroundDecoration: UICollectionReusableView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
    }
    

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}



private extension SectionBackgroundDecoration {
    
    func setupView() {
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 12
    }
}
