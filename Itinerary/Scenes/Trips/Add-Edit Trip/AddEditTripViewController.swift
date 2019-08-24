//
//  AddTripViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/4/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol AddEditTripViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: AddEditTripViewController)
    func viewController(_ controller: AddEditTripViewController, didAdd newTrip: Trip)
}


class AddEditTripViewController: UITableViewController {
    @IBOutlet private var destinationTextField: UITextField!
    @IBOutlet private var destinationTextFieldLabel: UILabel!
    @IBOutlet private var doneButton: UIBarButtonItem!
    @IBOutlet private var mainTitleLabel: UILabel!
    @IBOutlet var imagePickerButton: UIButton!
    
    
    weak var delegate: AddEditTripViewControllerDelegate?
    var modelController: TripsModelController!
    
    var viewModel: ViewModel! {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.render(with: self.viewModel)
            }
        }
    }
    
    
    static func instantiate(
        viewModel: ViewModel,
        modelController: TripsModelController,
        delegate: AddEditTripViewControllerDelegate? = nil
    ) -> AddEditTripViewController {
        let viewController = AddEditTripViewController.instantiateFromStoryboard(
            named: R.storyboard.addEditTrip.name
        )
        
        viewController.viewModel = viewModel
        viewController.modelController = modelController
        viewController.delegate = delegate
        
        return viewController
    }
}


// MARK: - Computeds
extension AddEditTripViewController {
    var canUsePhotoLibrary: Bool { UIImagePickerController.isSourceTypeAvailable(.photoLibrary) }
    
    var tripFromFormData: Trip {
        guard let destination = destinationTextField.text else {
            preconditionFailure("No text value found in destination field")
        }
        
        let imageData: Data?
        if imagePickerButton.imageView?.image?.isSymbolImage ?? false {
            imageData = imagePickerButton.imageView?.image?.jpegData(compressionQuality: 0.8)
        } else {
            imageData = nil
        }
        
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
extension AddEditTripViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        render(with: viewModel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.destinationTextField.becomeFirstResponder()
        }
    }
}



// MARK: - Event Handling
extension AddEditTripViewController {
    
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
private extension AddEditTripViewController {
    
    func setupUI() {
        Style.Label
            .xLargeBoldTitle(color: UIColor.Theme.accent1)
            .apply(to: mainTitleLabel)
        
        Style.Label.formLabel().apply(to: destinationTextFieldLabel)
        Style.TextField.inset().apply(to: destinationTextField)
        Style.Button.systemImage(named: "camera").apply(to: imagePickerButton)
    }
    
    
    func submitTripData() {
        let newTrip = tripFromFormData
        
        modelController.create(newTrip) { [weak self] _ in
            self?.delegate?.viewController(self!, didAdd: newTrip)
        }
    }
    
    
    func save(pickedImage: Data) {

    }
    
    
    func render(with viewModel: ViewModel) {
        mainTitleLabel.text = viewModel.mainTitleText
        
        destinationTextField.text = viewModel.tripToEdit?.title ?? ""
        destinationTextFieldChanged()
    }
}


// MARK: - UIImagePickerControllerDelegate
extension AddEditTripViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        let imageToSave: UIImage
        
        if let editedImage = info[.editedImage] as? UIImage {
            imageToSave = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageToSave = originalImage
        } else {
            return
        }
        
        DispatchQueue.main.async {
            self.imagePickerButton.setImage(imageToSave, for: .normal)
        }
        
        dismiss(animated: true)
    }
}


extension AddEditTripViewController: Storyboarded {}
extension AddEditTripViewController: UINavigationControllerDelegate {}
