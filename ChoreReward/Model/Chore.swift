//
//  Chore.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import Foundation
import SwiftUI

struct Chore: Identifiable, Codable{
    var id: String
    var title: String
    var assigner: User
    var assignee: User
    
    static let preview = Chore(
        id: UUID().uuidString,
        title: "Wash the dishes",
        assigner: User.previewDavid,
        assignee: User.previewTim
    )
    
    enum RewardType: String, CaseIterable, Identifiable{
        case goal
        case monetary
        
        var id: String {self.rawValue}
    }
}


