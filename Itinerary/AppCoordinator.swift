//
//  AppCoordinator.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class AppCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let window: UIWindow
    
    private var tripsCoordinator: TripsCoordinator?
    
    
    init(
        navController: UINavigationController,
        window: UIWindow
    ) {
        self.navController = navController
        self.window = window
    }
    
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        Appearance.apply(to: window)
        
        showTrips()
    }
}


// MARK: - Navigation

extension AppCoordinator {
    
    func showTrips() {
        tripsCoordinator = TripsCoordinator(navController: navController)
        
        tripsCoordinator?.start()
    }

}
