//
//  Chore.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import Foundation
import SwiftUI

struct Chore: Identifiable{
    var id: String
    var title: String
    var finished: Bool
    var choreBefore: String
    var choreAfter: String
    var whoCanTakeThis: [User]
    var whoTookThis: User?
    var reward: Reward
    
    static let previewUnfinished = Chore(
        id: UUID().uuidString,
        title: "Wash the dishes",
        finished: false,
        choreBefore: "unfinishedDishes",
        choreAfter: "finishedDishes",
        whoCanTakeThis: [User.previewBen, User.previewTim],
        whoTookThis: nil,
        reward: Reward.previewReward
        )
    
    static let previewFinished = Chore(
        id: UUID().uuidString,
        title: "Wash the dishes",
        finished: true,
        choreBefore: "unfinishedDishes",
        choreAfter: "finishedDishes",
        whoCanTakeThis: [User.previewBen, User.previewTim],
        whoTookThis: User.previewTim,
        reward: Reward.previewReward
        )
}


