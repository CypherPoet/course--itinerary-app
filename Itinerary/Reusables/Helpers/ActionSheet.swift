//
//  ActionSheet.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

enum Alert {
    enum Actions {
        typealias Handler = ((UIAlertAction) -> Void)
        
        func basicDefault(title: String? = nil, handler: Handler? = nil) -> UIAlertAction {
            let action = UIAlertAction(title: nil, style: .default, handler: handler)
     
            return action
        }
    }
}
