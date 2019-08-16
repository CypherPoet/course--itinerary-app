//
//  AppStateController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


final class AppStateController {
    private static let defaultDefaults: [String: Any] = [
        AppUserDefaults.isFirstRunOfApp.keyName: true
    ]
    
    
    init(initialDefaults: [String: Any] = defaultDefaults) {
        UserDefaults.standard.register(defaults: initialDefaults)
    }
}
