//
//  TripItineraryCoordinator.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol TripItineraryCoordinatorDelegate: class {

    func coordinator(
        _ coordinator: TripItineraryCoordinator,
        didAdd newDay: TripDay,
        to trip: Trip,
        then completionHandler: @escaping ((Result<Trip, Error>) -> Void)
    )
    
    func coordinator(
        _ coordinator: TripItineraryCoordinator,
        didAdd newActivity: TripActivity,
        to day: TripDay,
        for trip: Trip,
        then completionHandler: @escaping ((Result<Trip, Error>) -> Void)
    )
}


final class TripItineraryCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    
    var modelController: TripActivitiesModelController
    

    var tripActivitiesViewController: TripActivitiesViewController!
    weak var delegate: TripItineraryCoordinatorDelegate?
    
    
    init(
        modelController: TripActivitiesModelController,
        navController: UINavigationController,
        delegate: TripItineraryCoordinatorDelegate?
    ) {
        self.modelController = modelController
        self.navController = navController
        self.delegate = delegate
    }
}


// MARK: - Computeds
extension TripItineraryCoordinator {
    var trip: Trip { modelController.trip }
}


// MARK: - Coordinator
extension TripItineraryCoordinator: Coordinator {
    
    func start() {
        showActivitiesView()
    }
}


// MARK: - Private Helpers
private extension TripItineraryCoordinator {
  
    func showActivitiesView() {
        tripActivitiesViewController = TripActivitiesViewController.instantiate(
            viewModel: TripActivitiesViewModel(),
            tripDays: trip.days,
            delegate: self
        )
        
        tripActivitiesViewController.title = trip.title
        tripActivitiesViewController.navigationItem.largeTitleDisplayMode = .never
        
        navController.pushViewController(tripActivitiesViewController, animated: true)
    }
    
    
    func presentChildNavController(for viewController: UIViewController) {
        let childNavController = UINavigationController(rootViewController: viewController)
        
        Appearance.apply(to: childNavController.navigationBar)
        navController.present(childNavController, animated: true)
    }
}


// MARK: - TripActivitiesViewControllerDelegate
extension TripItineraryCoordinator: TripActivitiesViewControllerDelegate {

    func viewControllerDidSelectAddDay(_ controller: TripActivitiesViewController) {
        let newDayVC = AddEditDayViewController.instantiate(
            viewModel: AddEditDayViewModel(),
            delegate: self
        )
        
        newDayVC.title = trip.title
        
        presentChildNavController(for: newDayVC)
    }
    
    
    func viewControllerDidSelectAddActivity(_ controller: TripActivitiesViewController) {
        let newActivitesVC = AddEditActivityViewController.instantiate(
            viewModel: AddEditActivityViewModel(
                availableDays: trip.days,
                availableActivityTypes: TripActivityType.allCases
            ),
            delegate: self
        )
        
        newActivitesVC.title = trip.title
        presentChildNavController(for: newActivitesVC)
    }
}


// MARK: - AddEditDayViewControllerDelegate
extension TripItineraryCoordinator: AddEditDayViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: AddEditDayViewController) {
        navController.dismiss(animated: true)
    }
    
    func viewController(_ controller: AddEditDayViewController, didAdd newDay: TripDay) {
        delegate?.coordinator(self, didAdd: newDay, to: trip) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newTrip):
                self.navController.dismiss(animated: true)

                self.modelController.trip = newTrip
                self.tripActivitiesViewController.tripDays = self.modelController.sortedDays
            case .failure(let error):
                let alertMessage: String
                
                if case TripsModelController.Error.dayConflict = error {
                    alertMessage = "This trip already has a day created for \(newDay.date.formattedDay)"
                } else {
                    alertMessage = "An error occurred while trying to add a new day. Please try again."
                }
                
                self.navController.display(alertMessage: alertMessage)
            }
        }
    }
    
    
}



// MARK: - AddEditActivityViewControllerDelegate
extension TripItineraryCoordinator: AddEditActivityViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: AddEditActivityViewController) {
        navController.dismiss(animated: true)
    }
    
    
    func viewController(
        _ controller: AddEditActivityViewController,
        didAdd newActivity: TripActivity,
        for day: TripDay
    ) {
        
        delegate?.coordinator(self, didAdd: newActivity, to: day, for: trip) {
            [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newTrip):
                self.navController.dismiss(animated: true, completion: {
                    self.modelController.trip = newTrip
                    self.tripActivitiesViewController.tripDays = self.modelController.sortedDays
                })
            case .failure(let error):
                self.navController.display(
                    alertMessage: "An error occurred while trying to add a new activity. Please try again."
                )
            }
        }
    }
}
