//
//  MockData.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/19/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

enum MockData {
    
    static let trips = createMockTrips()
    
    
    private static func createMockTrips() -> [Trip] {
        let mockImageData = R.image.catalina()?.jpegData(compressionQuality: 0.8)
        
        return [
            Trip(title: "Trip to NYC", shortDescription: "🗽⚡️", primaryImageData: mockImageData, days: createMockDays()),
            Trip(title: "Trip to Chicago", shortDescription: "🏰⚡️", days: createMockDays()),
            Trip(title: "Trip to London", shortDescription: "🇬🇧⚡️", days: createMockDays()),
            Trip(title: "Trip to Paris", shortDescription: "🇫🇷⚡️", days: createMockDays()),
        ]
    }
    
    
    private static let day1 = Calendar.current.date(byAdding: DateComponents(day: 1), to: Date(), wrappingComponents: true)
    private static let day2 = Calendar.current.date(byAdding: DateComponents(day: 1), to: day1!, wrappingComponents: true)
    private static let day3 = Calendar.current.date(byAdding: DateComponents(day: 1), to: day2!, wrappingComponents: true)
    private static let day4 = Calendar.current.date(byAdding: DateComponents(day: 1), to: day3!, wrappingComponents: true)
    
    
    
    private static func createMockDays() -> [TripDay] {
        [day1, day2, day3, day4].compactMap({ $0 }).map { day -> TripDay in
            TripDay(date: day, subtitle: daySubtitles.randomElement()!, activities: createMockActivities(on: day))
        }
    }
    
    
    private static func createMockActivities(on day: Date) -> [TripActivity] {
        switch day {
        case day1, day4:
            return [
                TripActivity(title: "Flight from Home", subtitle: "First Class Seating", activityType: .flight, photoData: nil),
                TripActivity(title: "Arrive at Airport", subtitle: "", activityType: .flight, photoData: nil),
            ]
        case day2, day3:
            return [
                TripActivity(title: "Visit Museum", subtitle: "Take Plenty of Photos", activityType: .exploration, photoData: nil),
                TripActivity(title: "Cafe", subtitle: "☕️", activityType: .food, photoData: nil),
            ]
        default:
            preconditionFailure("Unknown day")
        }
    }
    
    
    private static let daySubtitles = [
        "Travel",
        "Exploration",
    ]
}
