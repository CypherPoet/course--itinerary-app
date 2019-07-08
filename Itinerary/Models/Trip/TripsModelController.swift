//
//  TripsModelController.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


final class TripsModelController {
    private let dataLoader: DataLoader
    private(set) var trips: [Trip] = []

    
    init(dataLoader: DataLoader = DataLoader()) {
        self.dataLoader = dataLoader
    }
}


extension TripsModelController {
    
    func loadTrips(then completionHandler: @escaping (Result<[Trip], Error>) -> Void) {
        let url = Endpoint.Trip.localURL
        
        dataLoader.load(from: url) { [weak self] dataResult in
            guard let self = self else { return }
            
            switch dataResult {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    self.trips = try decoder.decode([Trip].self, from: data)
                    completionHandler(.success(self.trips))
                } catch {
                    print("Error while attempting to decode trips: \(error.localizedDescription)")
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                print("Error while attempting to load trips: \(error.localizedDescription)")
                completionHandler(.failure(error))
            }
        }
    }
    
    
    
    func create(_ trip: Trip) {
        
    }
    
    
    func update(_ updatedTrip: Trip) {
        
    }
    
    
    func deleteTrip(withID: Trip) {
        
    }
}
