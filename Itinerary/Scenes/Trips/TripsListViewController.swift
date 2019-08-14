//
//  TripsListViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol TripsListViewControllerDelegate: class {
    func viewControllerDidSelectAddTrip(_ controller: TripsListViewController)
    func viewController(_ controller: TripsListViewController, didSelectEditingFor trip: Trip)
}


final class TripsListViewController: UIViewController, Storyboarded {
    @IBOutlet private var tableView: UITableView!
    
    
    weak var delegate: TripsListViewControllerDelegate?
    var modelController: TripsModelController!
    

    private var currentDataSnapshot: DataSourceSnapshot!
    private var dataSource: DataSource!
}


// MARK: - Table View Structure
extension TripsListViewController {
    enum TableSection: CaseIterable {
        case all
    }
    
    typealias DataSource = UITableViewDiffableDataSource<TableSection, Trip>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<TableSection, Trip>
}



// MARK: - Lifecycle
extension TripsListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No modelController was set")
        
        modelController.addTripsObserver(self)
        dataSource = makeTableViewDataSource()
        setupTableView()

        loadTrips()
    }
}


// MARK: - Event Handling
extension TripsListViewController {
    
    @IBAction func addButtonTapped() {
        delegate?.viewControllerDidSelectAddTrip(self)
    }
}


// MARK: - TripsModelControllerObserver
extension TripsListViewController: TripsModelControllerObserver {

    func modelController(_ controller: TripsModelController, didUpdate trips: [Trip]) {
        DispatchQueue.main.async { self.updateSnapshot(withNew: trips) }
    }
}


// MARK: - Private Helpers
private extension TripsListViewController {
    
    func makeTableViewDataSource() -> DataSource {
        DataSource(
            tableView: tableView,
            cellProvider: {
                [weak self] (tableView, indexPath, trip) -> UITableViewCell? in
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: R.reuseIdentifier.tripTableCell,
                    for: indexPath
                ) else {
                    preconditionFailure("Unable to dequeue cell")
                }
                
                self?.configure(cell, with: trip)
                
                return cell
            }
        )
    }
    
    
    func loadTrips() {
        modelController.loadTrips()
    }
    
    
    func configure(_ cell: TripTableViewCell, with trip: Trip) {
        let primaryImage: UIImage?
        if let primaryImageData = trip.primaryImageData {
            primaryImage = UIImage(data: primaryImageData)
        } else {
            primaryImage = nil
        }
        
        cell.viewModel = TripTableViewCell.ViewModel(
            title: trip.title,
            subtitle: trip.shortDescription,
            primaryImage: primaryImage
        )
    }
    
    
    func setupTableView() {
        tableView.register(
            TripTableViewCell.nib,
            forCellReuseIdentifier: R.nib.tripTableViewCell.identifier
        )
        
        tableView.delegate = self
    }

    
    func updateSnapshot(withNew trips: [Trip]) {
        guard let dataSource = dataSource else { return }
        
        currentDataSnapshot = DataSourceSnapshot()
        
        currentDataSnapshot.appendSections([.all])
        currentDataSnapshot.appendItems(trips)
        
        dataSource.apply(currentDataSnapshot, animatingDifferences: true)
    }
    
    
    func editTrip(
        at indexPath: IndexPath,
        usingSwipeCompletionHandler completionHandler: @escaping (Bool) -> Void
    ) {
        guard let tripToEdit = dataSource.itemIdentifier(for: indexPath) else {
            preconditionFailure("Unable to find trip to delete")
        }
        
        completionHandler(true)
        delegate?.viewController(self, didSelectEditingFor: tripToEdit)
    }
    
    
    func deleteTrip(
        at indexPath: IndexPath,
        usingSwipeCompletionHandler completionHandler: @escaping (Bool) -> Void
    ) {
        guard let tripToDelete = dataSource.itemIdentifier(for: indexPath) else {
            preconditionFailure("Unable to find trip to delete")
        }
        
        display(
            promptMessage: "Deleting this trip is a permanant action.",
            titled: "Are You Sure?",
            confirmButtonTitle: "Delete",
            cancelButtonTitle: "Cancel",
            confirmationHandler: { [weak self] _ in
                self?.modelController.delete(tripToDelete)
                completionHandler(true)
            },
            confirmationStyle: .destructive,
            cancelationHandler: { _ in
                completionHandler(false)
            }
        )
    }
}


// MARK: - UITableViewDelegate
extension TripsListViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(
            style: .normal,
            title: nil,
            handler: { [weak self] (_, _, completionHandler: @escaping (Bool) -> Void) in
                self?.editTrip(at: indexPath, usingSwipeCompletionHandler: completionHandler)
            }
        )
        
        editAction.backgroundColor = UIColor.Theme.tint
        editAction.image = UIImage(systemName: "pencil")
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { [weak self] (_, _, completionHandler: @escaping (Bool) -> Void) in
                self?.deleteTrip(at: indexPath, usingSwipeCompletionHandler: completionHandler)
            }
        )
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
