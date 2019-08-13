//
//  TaskToken.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


/// Allows for initialization of an object that abstracts
/// a cancellable task from the task itself by providing a `cancel` handler.
///
/// This can be useful for cancellable `URLSession` data tasks.
///
/// Kudos to https://www.swiftbysundell.com/posts/using-tokens-to-handle-async-swift-code
/// for the inspiration.
protocol TaskToken: class {
    associatedtype Task
    
    init(task: Task)
    
    func resume()
    func cancel()
    
    var taskURL: URL? { get }
}
