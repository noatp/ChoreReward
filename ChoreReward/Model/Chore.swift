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
    var whoCanTakeThis: String
    var whoTookThis: String
    var reward: Reward
    
    static let previewUnfinished = Chore(
        id: UUID().uuidString,
        title: "Wash the dishes",
        finished: false,
        choreBefore: "unfinishedDishes",
        choreAfter: "finishedDishes",
        whoCanTakeThis: "Timothy, Benjamin",
        whoTookThis: "",
        reward: Reward(unit: "Dollar", amount: 100))
    
    static let previewFinished = Chore(
        id: UUID().uuidString,
        title: "Wash the dishes",
        finished: true,
        choreBefore: "unfinishedDishes",
        choreAfter: "finishedDishes",
        whoCanTakeThis: "Timothy, Benjamin",
        whoTookThis: "Timothy",
        reward: Reward(unit: "Dollar", amount: 100))
}


