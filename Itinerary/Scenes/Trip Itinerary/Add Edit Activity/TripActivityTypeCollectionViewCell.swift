//
//  TripActivityTypeCollectionViewCell.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class TripActivityTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageViewContainer: UIView!
    @IBOutlet private var imageView: UIImageView!
    
    
    var activityType: TripActivityType? {
        didSet {
            DispatchQueue.main.async {
                self.imageView.image = self.activityType?.iconImage
            }
        }
    }
    
    override var isSelected: Bool {
        didSet { DispatchQueue.main.async { self.animateSelection() } }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViews()
    }
}


extension TripActivityTypeCollectionViewCell {
    static var nib: UINib {
        UINib(nibName: R.nib.tripActivityTypeCollectionViewCell.name, bundle: nil)
    }
}


private extension TripActivityTypeCollectionViewCell {
    
    func styleViews() {
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.size.width / 2
        imageViewContainer.layer.cornerRadius = imageViewContainer.frame.size.width / 2
        imageViewContainer.clipsToBounds = true
        
        imageViewContainer.backgroundColor = UIColor.tertiarySystemBackground
    }
    
    
    func animateSelection() {
        let newColor = isSelected ? UIColor.Theme.accent2 : UIColor.systemFill
        
        UIView.animate(
            withDuration: 0.18,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.imageViewContainer.tintColor = newColor
            }
        )
    }
}
