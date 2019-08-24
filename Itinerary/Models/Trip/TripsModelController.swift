//
//  TripsModelController.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


protocol TripsModelControllerObserver: class {
    func modelController(_ controller: TripsModelController, didUpdate trips: [Trip])
}


final class TripsModelController {
    private let dataLoader: DataLoader
    private var tripsObservers: [TripsModelControllerObserver] = []
    
    private(set) var trips: [Trip] = [] {
        didSet { notifyTripsObservers() }
    }

    
    init(dataLoader: DataLoader = DataLoader()) {
        self.dataLoader = dataLoader
    }
}

extension TripsModelController {
    enum TripsModelControllerError: Error {
        case dayConflict
    }
}


// MARK: - Core Methods
extension TripsModelController {
    
    typealias TripsCompletionHandler = (Result<[Trip], Error>) -> Void
    typealias TripCompletionHandler = (Result<Trip, Error>) -> Void
    
    
    func addTripsObserver(_ observer: TripsModelControllerObserver) {
        tripsObservers.append(observer)
    }
    
    
    func removeTripsObserver(_ observer: TripsListViewController) {
//        tripsObservers.remove(at: index)
    }
    
    
    func loadTrips(then completionHandler: TripsCompletionHandler? = nil) {
        let url = Endpoint.Trip.localURL
        
        dataLoader.load(from: url) { [weak self] dataResult in
            guard let self = self else { return }
            
            switch dataResult {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    self.trips = try decoder.decode([Trip].self, from: data)
                    completionHandler?(.success(self.trips))
                } catch {
                    print("Error while attempting to decode trips: \(error.localizedDescription)")
                    completionHandler?(.failure(error))
                }
            case .failure(let error):
                print("Error while attempting to load trips: \(error.localizedDescription)")
                completionHandler?(.failure(error))
            }
            
            self.trips = MockData.trips
        }
    }
    
    
    func create(_ trip: Trip, then completionHandler: TripsCompletionHandler? = nil) {
        trips.append(trip)
        completionHandler?(.success(trips))
    }
    
    
    func create(
        _ newDay: TripDay,
        for trip: Trip,
        then completionHandler: TripCompletionHandler? = nil
    ) {
        guard let tripIndex = trips.firstIndex(of: trip) else {
            preconditionFailure("Trip not found")
        }
        
        var tripToUpdate = trips[tripIndex]
        
        guard tripToUpdate.days.allSatisfy({ $0.isOnDifferentDay(than: newDay) }) else {
            completionHandler?(.failure(TripsModelControllerError.dayConflict))
            return
        }
        
        tripToUpdate.days.append(newDay)
        trips[tripIndex] = tripToUpdate
        
        completionHandler?(.success(tripToUpdate))
    }
    
    
    func update(_ updatedTrip: Trip, then completionHandler: TripsCompletionHandler? = nil) {
        
    }
    
    
    func delete(_ trip: Trip, then completionHandler: TripsCompletionHandler? = nil) {
        guard let index = trips.firstIndex(of: trip) else {
            preconditionFailure("Unable to find index for trip")
        }
        
        trips.remove(at: index)
        completionHandler?(.success(trips))
    }
}


// MARK: - Private Helpers

extension TripsModelController {
    
    func notifyTripsObservers() {
        tripsObservers.forEach {
            $0.modelController(self, didUpdate: trips)
        }
    }
}
