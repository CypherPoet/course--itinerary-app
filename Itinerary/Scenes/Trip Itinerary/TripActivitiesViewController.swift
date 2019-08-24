//
//  TripActivitiesViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol TripActivitiesViewControllerDelegate: class {
    func viewControllerDidSelectNewDay(_ controller: TripActivitiesViewController)
    func viewControllerDidSelectNewActivities(_ controller: TripActivitiesViewController)
}


class TripActivitiesViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    
    weak var delegate: TripActivitiesViewControllerDelegate?
    
    // swiftlint:disable implicitly_unwrapped_optional
    var viewModel: TripActivitiesViewModel!
    
    var tripDays: [TripDay] = [] {
        didSet {
            DispatchQueue.main.async {
                guard self.isViewLoaded else { return }
                self.createSnapshot(withNew: self.tripDays)
            }
        }
    }

    
    var currentDataSnapshot: DataSourceSnapshot!
    var dataSource: DataSource!
    // swiftlint:enable implicitly_unwrapped_optional
    

    static func instantiate(
        viewModel: TripActivitiesViewModel,
        tripDays: [TripDay],
        delegate: TripActivitiesViewControllerDelegate? = nil
    ) -> Self {
        let viewController = Self.instantiateFromStoryboard(
            named: R.storyboard.tripItinerary.name
        )
        
        viewController.viewModel = viewModel
        viewController.tripDays = tripDays
        viewController.delegate = delegate
        
        return viewController
    }
}


// MARK: - Lifecycle
extension TripActivitiesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = makeDataSource()
        setupLayout()
    }

    // TODO: Get this to actually work
    override var preferredStatusBarStyle: UIStatusBarStyle { .darkContent }
}


// MARK: - Private Helpers
private extension TripActivitiesViewController {
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: {
                [weak self] (collectionView, indexPath, tripActivity) -> UICollectionViewCell in
                
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: R.reuseIdentifier.tripActivityCell.identifier,
                    for: indexPath
                )
                
                self?.configure(cell, for: tripActivity)
                
                return cell
            }
        )
        
        dataSource.supplementaryViewProvider = makeSectionSupplementaryViewProvider()
        
        return dataSource
    }
    
    
    func setupLayout() {
        collectionView.register(
            TripActivityCollectionViewCell.nib,
            forCellWithReuseIdentifier: R.reuseIdentifier.tripActivityCell.identifier
        )
        
        collectionView.register(
            TripDayCollectionHeaderReusableView.nib,
            forSupplementaryViewOfKind: SupplementaryViewKind.sectionHeader,
            withReuseIdentifier: R.reuseIdentifier.tripDayCollectionSectionHeader.identifier
        )

        collectionView.collectionViewLayout = createLayout()

        collectionView.collectionViewLayout.register(
            SectionBackgroundDecoration.self,
            forDecorationViewOfKind: DecorationElementKind.sectionBackground
        )
    }
    
    
    func createSnapshot(withNew days: [TripDay], animate: Bool = true) {
        guard let dataSource = dataSource else { return }
        
        currentDataSnapshot = DataSourceSnapshot()
        currentDataSnapshot.appendSections(days)
        
        for day in days {
            currentDataSnapshot.appendItems(day.activities, toSection: day)
        }
        
        dataSource.apply(currentDataSnapshot, animatingDifferences: animate)
    }
}


// MARK: - Event Handling
extension TripActivitiesViewController {
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "What would you like to add?",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(
            title: "New Day",
            style: .default,
            handler: { [weak self] (_) in
                self?.delegate?.viewControllerDidSelectNewDay(self!)
            }
        ))
        
        alertController.addAction(UIAlertAction(
            title: "New Activities For Day",
            style: .default,
            handler: { [weak self] (_) in
                self?.delegate?.viewControllerDidSelectNewActivities(self!)
            }
        ))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.popoverPresentationController?.barButtonItem = sender

        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

extension TripActivitiesViewController: Storyboarded {}
