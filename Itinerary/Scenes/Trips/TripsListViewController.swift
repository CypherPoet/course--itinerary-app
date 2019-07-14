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
    
    typealias DataSource = TableViewDataSource<Trip>
    private var dataSource: DataSource?
    

    var modelController: TripsModelController!
    
    var trips: [Trip] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(modelController != nil, "No modelController was set")
        
        setupTableView()
        loadTrips()
    }
}


private extension TripsListViewController {
    
    func makeTableViewDataSource(with trips: [Trip]) -> DataSource {
        return TableViewDataSource(
            models: trips,
            cellReuseIdentifier: R.reuseIdentifier.tripTableCell.identifier,
            cellConfigurator: { [weak self] (trip, cell) in
                self?.configure(cell, with: trip)
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
                let dataSource = self.makeTableViewDataSource(with: self.trips)
                
                self.dataSource = dataSource
                self.tableView.dataSource = dataSource
                self.tableView.reloadData()
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
    
    
    func configure(_ cell: UITableViewCell, with trip: Trip) {
        guard let cell = cell as? TripTableViewCell else {
            preconditionFailure("Unknown cell type")
        }
        
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

}
