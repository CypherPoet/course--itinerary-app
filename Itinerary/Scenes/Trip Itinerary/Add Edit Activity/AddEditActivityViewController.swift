//
//  AddEditActivityViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol AddEditActivityViewControllerDelegate: class {
    func viewControllerDidCancel(_ controller: AddEditActivityViewController)
    
    func viewController(
        _ controller: AddEditActivityViewController,
        didAdd newActivity: TripActivity,
        for day: TripDay
    )
}


class AddEditActivityViewController: UITableViewController {
    @IBOutlet private var doneButton: UIBarButtonItem!
    @IBOutlet var activityTypeCollectionView: UICollectionView!
    @IBOutlet var dayPicker: UIPickerView!
    @IBOutlet var activityTitleField: UITextField!
    @IBOutlet var activitySubtitleField: UITextField!

    
    private var viewModel: AddEditActivityViewModel! {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.doneButton.isEnabled = self.canSubmitChanges
            }
        }
    }
    
    weak var delegate: AddEditActivityViewControllerDelegate?
    
    var dayPickerDataSource: DayPickerDataSource!
    var activityTypeDataSource: ActivityTypeDataSource!
    var activityTypeDataSourceSnapshot: ActivityTypeDataSourceSnapshot!
}


// MARK: - Initialization
extension AddEditActivityViewController {
    static func instantiate(
        viewModel: AddEditActivityViewModel,
        delegate: AddEditActivityViewControllerDelegate? = nil
    ) -> AddEditActivityViewController {
        let viewController = AddEditActivityViewController.instantiateFromStoryboard(
            named: R.storyboard.addEditActivity.name
        )
        
        viewController.viewModel = viewModel
        viewController.delegate = delegate
        
        return viewController
    }
}


// MARK: - Layout Structure
extension AddEditActivityViewController {
    enum ActivityTypeSection: String, CaseIterable {
        case all
    }
    
    typealias ActivityTypeDataSource = UICollectionViewDiffableDataSource<ActivityTypeSection, TripActivityType>
    typealias ActivityTypeDataSourceSnapshot = NSDiffableDataSourceSnapshot<ActivityTypeSection, TripActivityType>
}


// MARK: - Layout Composition
extension AddEditActivityViewController {
    
    func createActivityTypeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(66), heightDimension: .fractionalHeight(1.0))
        
        let activityTypeItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [activityTypeItem])

        group.interItemSpacing = .flexible(12)
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .continuous

        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    func makeActivityTypeDataSource() -> ActivityTypeDataSource {
        ActivityTypeDataSource(
            collectionView: activityTypeCollectionView,
            cellProvider: { (collectionView, indexPath, activityType) -> UICollectionViewCell? in
                guard
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: R.reuseIdentifier.tripActivityTypeCollectionCell.identifier,
                        for: indexPath
                    ) as? TripActivityTypeCollectionViewCell
                else {
                    preconditionFailure("Unknown cell type")
                }
                
                cell.activityType = activityType
                
                return cell
            }
        )
    }
    
    
    func createActivityTypeSnapshot(with availableActivityTypes: [TripActivityType], animate: Bool = true) {
        guard activityTypeDataSource != nil else { return }
        
        var snapshot = ActivityTypeDataSourceSnapshot()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(availableActivityTypes, toSection: .all)
        
        activityTypeDataSource.apply(snapshot, animatingDifferences: animate)
    }
    

    func setupActivityTypeCollectionView() {
        activityTypeCollectionView.register(
            TripActivityTypeCollectionViewCell.nib,
            forCellWithReuseIdentifier: R.reuseIdentifier.tripActivityTypeCollectionCell.identifier
        )
        
        activityTypeCollectionView.collectionViewLayout = createActivityTypeLayout()
        activityTypeCollectionView.delegate = self
    }
}



// MARK: - Computeds
extension AddEditActivityViewController {
    var canSubmitChanges: Bool {
        (
            viewModel.activityTitle != nil &&
            viewModel.activitySubtitle != nil &&
            viewModel.selectedDay != nil &&
            viewModel.selectedType != nil
        )
    }

    
    var activityFromFormData: TripActivity? {
        guard canSubmitChanges else { return nil }
        
        return TripActivity(
            title: viewModel.activityTitle!,
            subtitle: viewModel.activitySubtitle!,
            activityType: viewModel.selectedType!
        )
    }
}


// MARK: - Lifecycle
extension AddEditActivityViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        activityTypeDataSource = makeActivityTypeDataSource()
        setupActivityTypeCollectionView()
        
        viewModel.selectedDay = viewModel.selectedDay ?? viewModel.availableDays.first
        setupUI(with: viewModel)
    }
}


// MARK: - Event Handling
extension AddEditActivityViewController {
    
    @IBAction func cancelButtonTapped() {
        delegate?.viewControllerDidCancel(self)
    }
    
    
    @IBAction func doneButtonTapped() {
        submitData()
    }
    
    
    @IBAction func titleTextFieldChanged() {
        viewModel.activityTitle = activityTitleField.text
    }
    

    @IBAction func subtitleTextFieldChanged() {
        viewModel.activitySubtitle = activitySubtitleField.text
    }
}


// MARK: - Private Helpers
private extension AddEditActivityViewController {
    
    func setupUI(with viewModel: AddEditActivityViewModel) {
        createActivityTypeSnapshot(with: viewModel.availableActivityTypes)
        setupDayPicker(with: viewModel.availableDays, startingAt: viewModel.selectedDayIndex)
        
        activityTitleField.text = viewModel.activityTitle
        activitySubtitleField.text = viewModel.activitySubtitle
        
        doneButton.isEnabled = canSubmitChanges
    }
    
    
    func setupDayPicker(with days: [TripDay], startingAt startingIndex: Int? = 0) {
        let dayPickerDataSource = DayPickerDataSource(days: days)
        
        self.dayPickerDataSource = dayPickerDataSource
        dayPicker.dataSource = dayPickerDataSource
        dayPicker.delegate = self

        if let startingIndex = startingIndex {
            dayPicker.selectRow(startingIndex, inComponent: 0, animated: false)
        }
    }
    
    
    func submitData() {
        guard
            let selectedDay = viewModel.selectedDay,
            let activity = activityFromFormData
        else { preconditionFailure("Incomplete data for submission") }
        
        delegate?.viewController(self, didAdd: activity, for: selectedDay)
    }
}


// MARK: - UIPickerViewDelegate
extension AddEditActivityViewController: UIPickerViewDelegate {
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        dayPickerDataSource.days[row].date.formattedDay
    }
    
    
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        viewModel.selectedDay = dayPickerDataSource.days[row]
    }
}


// MARK: - UICollectionViewDelegate
extension AddEditActivityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let activityType = activityTypeDataSource.itemIdentifier(for: indexPath) else {
            preconditionFailure("Unable to get activity type for indexPath")
        }
        
        viewModel.selectedType = activityType
    }
}


extension AddEditActivityViewController: Storyboarded {}
