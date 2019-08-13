//
//  DataTaskToken.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/10/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


final class DownloadTaskToken: TaskToken {
    private weak var task: URLSessionDownloadTask?
    
    
    init(task: URLSessionDownloadTask) {
        self.task = task
    }
    
    
    func resume() {
        task?.resume()
    }
    
    
    func cancel() {
        task?.cancel()
    }
    
    var taskURL: URL? { task?.currentRequest?.url }
}
