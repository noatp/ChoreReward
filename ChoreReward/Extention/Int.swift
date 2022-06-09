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
}
