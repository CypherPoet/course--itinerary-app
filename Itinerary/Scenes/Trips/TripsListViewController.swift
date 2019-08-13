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
}


final class TripsListViewController: UIViewController, Storyboarded {
    @IBOutlet private var tableView: UITableView!
    
    
    weak var delegate: TripsListViewControllerDelegate?
    var modelController: TripsModelController!
    
    
//    var trips: [Trip] = [] {
//        didSet {
//            DispatchQueue.main.async { self.updateSnapshot(withNew: self.trips) }
//        }
//    }
    
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
    }

    
    func updateSnapshot(withNew trips: [Trip]) {
        guard let dataSource = dataSource else { return }
        
        currentDataSnapshot = DataSourceSnapshot()
        
        currentDataSnapshot.appendSections([.all])
        currentDataSnapshot.appendItems(trips)
        
        dataSource.apply(currentDataSnapshot, animatingDifferences: true)
    }
}
