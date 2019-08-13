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
    @IBOutlet private var primaryImageView: UIImageView!

    private lazy var imageBlurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
    private lazy var imageVibrancyEffect = UIVibrancyEffect(blurEffect: imageBlurEffect, style: .label)

    
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
        
        if let primaryImage = viewModel.primaryImage {
            primaryImageView.image = primaryImage
            primaryImageView.isHidden = false
            
            blurPrimaryImageView()
        }
    }
    
    
    func setupView() {
        Style.TripCard.standard.apply(to: cardContainerView)
        
        Style.Label
            .largeBoldTitle(color: UIColor.Theme.accent1)
            .withAdjustment({
                $0.addShadow(
                    opacity: 0.41,
                    radius: 8,
                    offset: CGSize(width: 0, height: 6),
                    color: UIColor.systemGray6.cgColor
                )
            })
            .apply(to: titleLabel)
        
        Style.Label.subheadline
            .withAdjustment({
                $0.textColor = UIColor.Theme.accent2
        
                $0.addShadow(
                    opacity: 0.31,
                    radius: 6,
                    offset: CGSize(width: 0, height: 6),
                    color: UIColor.systemGray6.cgColor
                )
            })
            .apply(to: subtitleLabel)
    }
    
    
    func blurPrimaryImageView() {
        let imageBlurView = makeImageBlurView()
        let imageVibrancyView = makeVibrancyView(for: imageBlurView)
        imageBlurView.contentView.addSubview(imageVibrancyView)

        imageBlurView.clipsToBounds = true
        imageBlurView.layer.cornerRadius = cardContainerView.layer.cornerRadius
        primaryImageView.clipsToBounds = true
        primaryImageView.layer.cornerRadius = cardContainerView.layer.cornerRadius
        
        cardContainerView.insertSubview(imageBlurView, aboveSubview: primaryImageView)

        matchSizeContraints(for: imageBlurView, in: cardContainerView)
        matchSizeContraints(for: imageVibrancyView, in: imageBlurView)
    }
    
    
    func makeVibrancyView(for blurEffectView: UIVisualEffectView) -> UIVisualEffectView {
        guard let blurEffect = blurEffectView.effect as? UIBlurEffect else {
            preconditionFailure("Failed to initialize blurEffect")
        }
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .fill)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        
        return vibrancyView
    }
    
    
    func makeImageBlurView(with vibrancyView: UIVisualEffectView? = nil) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: imageBlurEffect)
            
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        if let vibrancyView = vibrancyView {
            blurView.contentView.addSubview(vibrancyView)
        }
        
        return blurView
    }
    

    func matchSizeContraints(for innerView: UIView, in containingView: UIView) {
        NSLayoutConstraint.activate([
            innerView.centerXAnchor.constraint(equalTo: containingView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: containingView.centerYAnchor),
            innerView.widthAnchor.constraint(equalTo: containingView.widthAnchor),
            innerView.heightAnchor.constraint(equalTo: containingView.heightAnchor),
        ])
    }
}
