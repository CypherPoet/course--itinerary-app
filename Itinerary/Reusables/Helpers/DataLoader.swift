//
//  DataLoader.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


final class DataLoader {
    
    func load(
        from url: URL,
        on queue: DispatchQueue = .global(qos: .userInitiated),
        then completionHandler: @escaping ((Result<Data, Error>) -> Void)
    ) {
        queue.async {
            do {
                let data = try Data(contentsOf: url)
                
                completionHandler(.success(data))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
}
