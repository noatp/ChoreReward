//
//  Reward.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import Foundation

struct Reward {
    var unit: RewardUnit
    var amount: Int

    static let previewReward = Reward(unit: RewardUnit.percentOfCurrentGoal, amount: 1)
}

enum RewardUnit: String, CaseIterable, Identifiable {
    case percentOfCurrentGoal
    case dollar

    var id: String {self.rawValue}
}
