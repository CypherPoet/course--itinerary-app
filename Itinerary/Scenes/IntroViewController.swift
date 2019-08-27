//
//  IntroViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/26/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

protocol IntroViewControllerDelegate: class {
    func viewControllerDidFinishAnimation(_ controller: IntroViewController)
}


class IntroViewController: UIViewController {
    @IBOutlet private var introView: IntroView!

    
    weak var delegate: IntroViewControllerDelegate?
    
    
    static func instantiate(
        delegate: IntroViewControllerDelegate
    ) -> IntroViewController {
        let viewController = IntroViewController.instantiateFromStoryboard(
            named: R.storyboard.trips.name
        )
        
        viewController.delegate = delegate
        
        return viewController
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        introView.animate { [weak self] _ in
            self?.fadeOutAndFinish()
        }
    }
}


private extension IntroViewController {
    
    func fadeOutAndFinish() {
//        view.fadeOut()
        delegate?.viewControllerDidFinishAnimation(self)
    }
}


extension IntroViewController: Storyboarded {}
