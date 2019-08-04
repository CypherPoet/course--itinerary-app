//
//  TripsListViewController.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


final class TripsListViewController: UIViewController, Storyboarded {
    @IBOutlet private var tableView: UITableView!
    
    
    var modelController: TripsModelController!
    
    
    private var trips: [Trip] = [] {
        didSet {
            DispatchQueue.main.async { self.updateSnapshot(withNew: self.trips) }
        }
    }
    
    private var dataSource: DataSource?
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
        
        dataSource = makeTableViewDataSource()
        setupTableView()
        loadTrips()
    }
}


// MARK: - Event Handling
extension TripsListViewController {
    
    @IBAction func addButtonTapped() {
        
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
        modelController.loadTrips { [weak self] (dataResult) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let dummyTrips = [
                    Trip(title: "Trip to NYC", shortDescription: "🗽⚡️"),
                    Trip(title: "Trip to Chicago", shortDescription: "🏰⚡️"),
                    Trip(title: "Trip to London", shortDescription: "🇬🇧⚡️"),
                    Trip(title: "Trip to Paris", shortDescription: "🇫🇷⚡️"),
                ]

                self.trips = dummyTrips
            }
            
            // TODO: Use real results instead of dummy data
            //            switch dataResult {
            //            case .success(let trips):
            //                tripsListVC.trips = trips
            //            case .failure:
            //                tripsListVC.trips = []
            //            }
        }
    }
    
    
    func configure(_ cell: TripTableViewCell, with trip: Trip) {
        cell.viewModel = TripTableViewCell.ViewModel(
            title: trip.title,
            subtitle: trip.shortDescription
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
        
        let snapshot = dataSource.snapshot()
        
        snapshot.appendSections([.all])
        snapshot.appendItems(trips)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
