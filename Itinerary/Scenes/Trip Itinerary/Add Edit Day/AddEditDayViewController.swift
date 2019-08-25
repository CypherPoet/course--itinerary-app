//
//  AddEditDayViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol AddEditDayViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: AddEditDayViewController)
    func viewController(_ controller: AddEditDayViewController, didAdd newDay: TripDay)
}


class AddEditDayViewController: UITableViewController {
    @IBOutlet private var doneButton: UIBarButtonItem!
    @IBOutlet private var subtitleTextField: UITextField!
    @IBOutlet private var dayPicker: UIDatePicker!
    
    
    weak var delegate: AddEditDayViewControllerDelegate?
    
    var viewModel: AddEditDayViewModel! {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.doneButton.isEnabled = self.canSubmitChanges
            }
        }
    }
    
    
    static func instantiate(
        viewModel: AddEditDayViewModel,
        delegate: AddEditDayViewControllerDelegate
    ) -> Self {
        let vc = Self.instantiateFromStoryboard(named: R.storyboard.addEditDay.name)
        
        vc.viewModel = viewModel
        vc.delegate = delegate
        
        return vc
    }
}


// MARK: - Computeds
extension AddEditDayViewController {
    var canSubmitChanges: Bool { viewModel.subtitle != nil }

    var dayFromFormData: TripDay {
        guard canSubmitChanges else { fatalError() }
        
        return TripDay(
            date: viewModel.dateForDay,
            subtitle: viewModel.subtitle!,
            activities: []
        )
    }
}


// MARK: - Lifecycle
extension AddEditDayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI(with: viewModel)
    }
}


// MARK: - Event Handling
extension AddEditDayViewController {
    
    @IBAction func cancelButtonTapped() {
        delegate?.viewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        submitData()
    }
    
    
    @IBAction func dayPickerChanged() {
        viewModel.dateForDay = dayPicker.date
    }
    
    
    @IBAction func subtitleTextFieldEndedOnExit() {
        if canSubmitChanges {
            submitData()
        }
    }
    

    @IBAction func subtitleTextFieldChanged() {
        viewModel.subtitle = subtitleTextField.text
    }
}


// MARK: - Private Helpers
private extension AddEditDayViewController {
    
    func setupUI(with viewModel: AddEditDayViewModel) {
        subtitleTextField.text = viewModel.subtitle
        dayPicker.minimumDate = viewModel.minimumDate
        dayPicker.date = viewModel.dateForDay
        
        doneButton.isEnabled = canSubmitChanges
    }
    
    
    func submitData() {
        delegate?.viewController(self, didAdd: dayFromFormData)
    }
}


extension AddEditDayViewController: Storyboarded {}
