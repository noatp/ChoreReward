//
//  Reward.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import Foundation

struct Reward: Codable {
    let name: String
    let value: Float

    static let empty = Reward(name: "", value: 0.00)
}
