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
        cardContainerView.layer.shadowOpacity = 1
        cardContainerView.layer.shadowRadius = 10
        cardContainerView.layer.shadowOffset = .zero
        cardContainerView.layer.shadowColor = UIColor.tertiaryLabel.cgColor
        cardContainerView.layer.cornerRadius = cardContainerView.frame.width * 0.05
    }
}
