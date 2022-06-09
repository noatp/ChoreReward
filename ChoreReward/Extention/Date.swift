//
//  Date.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/8/22.
//

import Foundation

extension Date {
    var intTimestamp: Int {
        return Int(self.timeIntervalSince1970)
    }
}
