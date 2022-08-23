//
//  Int.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/8/22.
//

import Foundation

extension Int {
    var dateTimestamp: Date {
        Date(timeIntervalSince1970: TimeInterval(self))
    }

    var stringDateDistanceFromNow: String {
        let formatter = DateComponentsFormatter()
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        return formatter.string(from: self.dateTimestamp.distance(to: .now)) ?? "0s"
    }
}
