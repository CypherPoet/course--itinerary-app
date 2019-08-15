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
    @IBOutlet var helpView: UIVisualEffectView!
    
    weak var delegate: TripsListViewControllerDelegate?
    
    
    override func loadView() {
        super.loadView()
            
        view = helpView
    }
    
    
    @IBAction func closeButtonTapped(_ button: UIButton) {
        
    }
}


extension TripsListHelpViewController: Storyboarded {}
