//
//  TripDayCollectionHeaderReusableView.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class TripDayCollectionHeaderReusableView: UICollectionReusableView {
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    
    
    var viewModel: ViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async { self.render(with: viewModel) }
        }
    }
}


// MARK: - Computeds
extension TripDayCollectionHeaderReusableView {
    static var nib: UINib {
        UINib(nibName: R.nib.tripDayCollectionHeaderReusableView.name, bundle: nil)
    }
}


// MARK: - Lifecycle
extension TripDayCollectionHeaderReusableView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleViews()
    }
}


// MARK: - Private Helpers
private extension TripDayCollectionHeaderReusableView {
    
    func render(with viewModel: ViewModel) {
        dateLabel.text = viewModel.dateLabelText
        subtitleLabel.text = viewModel.subtitle
    }
    
    
    func styleViews() {
        Style
            .Label
            .tableSectionHeader(color: UIColor.Theme.accent1)
            .apply(to: dateLabel)
        
        Style
            .Label
            .footnote(color: UIColor.Theme.accent3)
            .apply(to: subtitleLabel)
    }
}


// MARK: - ViewModel
extension TripDayCollectionHeaderReusableView {
    struct ViewModel {
        var date: Date
        var subtitle: String
        
        
        var dateLabelText: String { date.formattedDay }
    }
}
