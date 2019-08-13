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


class AddTripViewController: UITableViewController {
    @IBOutlet private var destinationTextField: UITextField!
    @IBOutlet private var destinationTextFieldLabel: UILabel!
    @IBOutlet private var doneButton: UIBarButtonItem!
    @IBOutlet private var headlineLabel: UILabel!
    @IBOutlet var imagePickerButton: UIButton!
    
    
    weak var delegate: AddTripViewControllerDelegate?
    var modelController: TripsModelController!
}


// MARK: - Computeds
extension AddTripViewController {
    var canUsePhotoLibrary: Bool { UIImagePickerController.isSourceTypeAvailable(.photoLibrary) }
    
    var newTripFromChanges: Trip {
        guard let destination = destinationTextField.text else {
            preconditionFailure("No text value found in destination field")
        }
        
        let imageData = imagePickerButton.imageView?.image?.jpegData(compressionQuality: 0.8)
        
        return Trip(
            title: destination,
            shortDescription: "",
            primaryImageData: imageData
        )
    }
    
    
    var tripPhotoImagePicker: UIImagePickerController {
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        
        return picker
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
    
    
    @IBAction func imagePickerButtonTapped() {
        let imagePicker = tripPhotoImagePicker
        
        if canUsePhotoLibrary {
            tripPhotoImagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true)
    }
}


// MARK: - Private Helpers
private extension AddTripViewController {
    
    func setupUI() {
        Style.Label
            .xLargeBoldTitle(color: UIColor.Theme.accent1)
            .apply(to: headlineLabel)
        
        Style.Label.formLabel.apply(to: destinationTextFieldLabel)
        Style.TextField.inset().apply(to: destinationTextField)
        Style.Button.systemImage(named: "camera").apply(to: imagePickerButton)
    }
    
    
    func submitTripData() {
        let newTrip = newTripFromChanges
        
        modelController.create(newTrip) { [weak self] _ in
            self?.delegate?.viewController(self!, didAdd: newTrip)
        }
    }
    
    
    func save(pickedImage: Data) {

    }
}


// MARK: - UIImagePickerControllerDelegate
extension AddTripViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.imagePickerButton.setImage(image, for: .normal)
            }
        }
        
        dismiss(animated: true)
    }
}


extension AddTripViewController: Storyboarded {}
extension AddTripViewController: UINavigationControllerDelegate {}
