//
//  TripActivityCollectionViewCell.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class TripActivityCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var contentContainerView: UIView!
    @IBOutlet private var activityTitleLabel: UILabel!
    @IBOutlet private var activitySubtitleLabel: UILabel!
    @IBOutlet private var activityTypeImageView: UIImageView!
    
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }
}



// MARK: - Computeds
extension TripActivityCollectionViewCell {
    static var nib: UINib {
        UINib(nibName: R.nib.tripActivityCollectionViewCell.name, bundle: nil)
    }
}


// MARK: - Lifecycle
extension TripActivityCollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViews()
    }
}


// MARK: - Private Helpers
private extension TripActivityCollectionViewCell {
    
    func render(with viewModel: ViewModel) {
        activityTitleLabel.text = viewModel.activityTitle
        activitySubtitleLabel.text = viewModel.activitySubtitle
        activityTypeImageView.image = viewModel.activityTypeImage
    }
    
    
    func styleViews() {
        let textColor = UIColor.systemGray3
        
        Style.TripActivityCell.standard.apply(to: contentContainerView)
        Style.Label.headline(color: textColor).apply(to: activityTitleLabel)
        Style.Label.subheadline(color: textColor).apply(to: activitySubtitleLabel)
        activityTypeImageView.tintColor = textColor
    }
}


// MARK: - ViewModel
extension TripActivityCollectionViewCell {
    struct ViewModel {
        var activityTitle: String
        var activitySubtitle: String
        var activityType: TripActivityType
        
        var activityTypeImage: UIImage? { activityType.iconImage }
    }
}
