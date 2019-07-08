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

    
    var trips: [Trip]? {
        didSet {
            guard let trips = trips else { return }
            
            DispatchQueue.main.async {
                let dataSource = self.makeTableViewDataSource(with: trips)

                self.dataSource = dataSource
                self.setupTableView(with: dataSource)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


private extension TripsListViewController {
    
    func makeTableViewDataSource(with trips: [Trip]) -> DataSource {
        return TableViewDataSource(
            models: trips,
            cellReuseIdentifier: R.reuseIdentifier.tripTableCell.identifier,
            cellConfigurator: { [weak self] (trip, cell) in
                cell.textLabel?.text = trip.title
            }
        )
    }
    
    
    func setupTableView(with dataSource: DataSource) {
        tableView.dataSource = dataSource
        tableView.reloadData()
    }

}
