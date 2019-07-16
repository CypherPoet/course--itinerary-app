//
//  TripTableViewCell.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/8/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    @IBOutlet private var cardContainerView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    

    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }
}


// MARK: - Lifecylce

extension TripTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
}


// MARK: - Computeds

extension TripTableViewCell {

    static var nib: UINib {
        .init(nibName: R.nib.tripTableViewCell.name, bundle: nil)
    }
}


// MARK: - Private Helpers

private extension TripTableViewCell {

    func render(with viewModel: ViewModel) {
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.subtitleText
    }
    
    
    func setupView() {
        Style.TripCard.standard.apply(to: cardContainerView)
        
        Style.Label.largeBoldTitle.apply(to: titleLabel)
        Style.Label.subheadline.apply(to: subtitleLabel)
    }
}
