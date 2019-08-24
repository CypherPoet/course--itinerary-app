//
//  TripsListHelpViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/14/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol TripsListHelpViewControllerDelegate: class {
    func viewControllerDidTapCloseButton(_ controller: TripsListHelpViewController)
}


class TripsListHelpViewController: UIViewController {
    @IBOutlet var closeButton: FilledActionButton!
    @IBOutlet var helpViewOverlay: UIVisualEffectView!
    
    weak var delegate: TripsListHelpViewControllerDelegate?
    
    
    static func instantiate(
        delegate: TripsListHelpViewControllerDelegate? = nil
    ) -> TripsListHelpViewController {
        let viewController = TripsListHelpViewController.instantiateFromStoryboard(
            named: R.storyboard.tripsListHelp.name
        )
        
        viewController.delegate = delegate
        
        return viewController
    }
}


extension TripsListHelpViewController {
    override func loadView() {
        super.loadView()
            
        view = helpViewOverlay
        
        closeButton.addTarget(self, action: #selector(TripsListHelpViewController.closeButtonTapped(_:)), for: .touchUpInside)
    }
}


extension TripsListHelpViewController {
    @objc func closeButtonTapped(_ button: UIButton) {
        delegate?.viewControllerDidTapCloseButton(self)
    }
}


extension TripsListHelpViewController: Storyboarded {}
