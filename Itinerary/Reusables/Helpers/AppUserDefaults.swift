//
//  AppUserDefaults.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/16/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


enum AppUserDefaults {
    static let isFirstRunOfApp = Key<Bool>(named: "Is First Run of App")
    
    
    struct Key<T> {
        let keyName: String
        
        init(named keyName: String) {
            self.keyName = keyName
        }
        
        
        func get() -> T? {
            return UserDefaults.standard.value(forKey: keyName) as? T
        }
        
        
        func get(defaultValue: T) -> T {
            return (UserDefaults.standard.value(forKey: keyName) as? T) ?? defaultValue
        }
        
        
        func set(_ value: T) {
            UserDefaults.standard.set(value, forKey: keyName)
        }
        
        
        func removeValue() {
            UserDefaults.standard.removeObject(forKey: keyName)
        }
    }
}
