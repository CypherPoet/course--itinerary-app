//
//  TripsCoordinator.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class TripsCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    
    lazy private var tripsModelController = TripsModelController()
    var tripItineraryCoordinator: TripItineraryCoordinator?
    
}


// MARK: - Coordinator
extension TripsCoordinator: Coordinator {
    
    func start() {
        let tripsListVC = TripsListViewController.instantiate(
            modelController: tripsModelController,
            delegate: self
        )
        
        let introViewController = IntroViewController.instantiate(delegate: self)
        
        tripsListVC.navigationItem.title = "My Trips"
        
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.isHidden = true
        navController.setViewControllers([tripsListVC, introViewController], animated: true)
    }
}

// MARK: - Private Helpers
private extension TripsCoordinator {
    
    func presentAddEditTripVC(editing tripToEdit: Trip? = nil) {
        let addEditTripVC = AddEditTripViewController.instantiate(
            viewModel: .init(tripToEdit: tripToEdit),
            modelController: tripsModelController,
            delegate: self
        )
        
        let childNavController = UINavigationController(rootViewController: addEditTripVC)
        Appearance.apply(to: childNavController.navigationBar)
        
        navController.present(childNavController, animated: true)
    }
    
    
    func showHelpViewOverlay() {
        let helpViewController = TripsListHelpViewController.instantiate(
            delegate: self
        )

        helpViewController.modalPresentationStyle = .fullScreen
        navController.present(helpViewController, animated: true)
    }
}


// MARK: TripsListViewControllerDelegate
extension TripsCoordinator: TripsListViewControllerDelegate {
    
    func viewController(_ controller: TripsListViewController, didSelectEditingFor trip: Trip) {
        presentAddEditTripVC(editing: trip)
    }
    
    
    func viewController(_ controller: TripsListViewController, didSelectItineraryFor trip: Trip) {
        tripItineraryCoordinator = TripItineraryCoordinator(
            modelController: TripActivitiesModelController(trip: trip),
            navController: navController,
            delegate: self
        )
        
        tripItineraryCoordinator?.start()
    }
    
    
    func viewControllerDidSelectAddTrip(_ controller: TripsListViewController) {
        presentAddEditTripVC()
    }
}


// MARK: AddTripViewControllerDelegate
extension TripsCoordinator: AddEditTripViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: AddEditTripViewController) {
        navController.dismiss(animated: true)
    }
    
    
    func viewController(_ controller: AddEditTripViewController, didAdd newTrip: Trip) {
        navController.dismiss(animated: true) 
    }
}


// MARK: - TripsListHelpViewControllerDelegate
extension TripsCoordinator: TripsListHelpViewControllerDelegate {

    func viewControllerDidTapCloseButton(_ controller: TripsListHelpViewController) {
        navController.dismiss(animated: true)
    }
}


// MARK: - TripItineraryCoordinatorDelegate
extension TripsCoordinator: TripItineraryCoordinatorDelegate {
    
    func coordinator(
        _ coordinator: TripItineraryCoordinator,
        didAdd newDay: TripDay,
        to trip: Trip,
        then completionHandler: @escaping ((Result<Trip, Error>) -> Void)
    ) {
        tripsModelController.create(newDay, for: trip) { result in
            switch result {
            case .success(let updatedTrip):
                completionHandler(.success(updatedTrip))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    

    func coordinator(
        _ coordinator: TripItineraryCoordinator,
        didAdd newActivity: TripActivity,
        to day: TripDay,
        for trip: Trip,
        then completionHandler: @escaping ((Result<Trip, Error>) -> Void)
    ) {
        tripsModelController.add(newActivity, to: day, in: trip) { result in
            switch result {
            case .success(let updatedTrip):
                completionHandler(.success(updatedTrip))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}


extension TripsCoordinator: IntroViewControllerDelegate {
    
    func viewControllerDidFinishAnimation(_ controller: IntroViewController) {
        controller.performRemoval()

        navController.viewControllers.removeAll(where: { $0 == controller })
        navController.navigationBar.isHidden = false
        
        if AppUserDefaults.isFirstRunOfApp.get(defaultValue: true) {
           AppUserDefaults.isFirstRunOfApp.set(false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.23) {
                self.showHelpViewOverlay()
            }
        }
    }
}
