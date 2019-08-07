//
//  AddTripViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol AddTripViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: AddTripViewController)
    func viewController(_ controller: AddTripViewController, didAdd newTrip: Trip)
}


class AddTripViewController: UIViewController {
    @IBOutlet private var destinationTextField: UITextField!
    @IBOutlet private var destinationTextFieldLabel: UILabel!
    @IBOutlet private var doneButton: UIBarButtonItem!
    @IBOutlet private var headlineLabel: UILabel!
    
    
    weak var delegate: AddTripViewControllerDelegate?
    var modelController: TripsModelController!
}


// MARK: - Computeds
extension AddTripViewController {
    
    var newTripFromChanges: Trip {
        guard let destination = destinationTextField.text else {
            preconditionFailure("No text value found in destination field")
        }
        
        return Trip(title: destination, shortDescription: "")
    }
}


// MARK: - Lifecycle
extension AddTripViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No modelController was set")

        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.destinationTextField.becomeFirstResponder()
        }
    }
}



// MARK: - Event Handling
extension AddTripViewController {
    
    @IBAction func cancelButtonTapped() {
        delegate?.viewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        submitTripData()
    }
    
    
    @IBAction func destinationTextFieldEndedOnExit() {
        submitTripData()
    }
    
    
    @IBAction func destinationTextFieldChanged() {
        doneButton.isEnabled = destinationTextField.hasText
    }
}


private extension AddTripViewController {
    
    func setupUI() {
        Style.Label
            .xLargeBoldTitle(color: UIColor.Theme.accent1)
            .apply(to: headlineLabel)
        
        Style.Label.formLabel.apply(to: destinationTextFieldLabel)
        Style.TextField.inset().apply(to: destinationTextField)
    }
    
    
    func submitTripData() {
        let newTrip = newTripFromChanges
        
        modelController.create(newTrip) { [weak self] result in
            self?.delegate?.viewController(self!, didAdd: newTrip)
        }
    }
}


extension AddTripViewController: Storyboarded {}
