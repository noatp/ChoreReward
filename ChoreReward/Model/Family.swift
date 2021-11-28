//
//  Family.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/5/21.
//

import Foundation

struct Family: Identifiable{
    var id: String
    var member: [User]
    var chores: [Chore]
    
    static let preview = Family(
        id: "tranfam",
        member: [User.previewDavid, User.previewTim, User.previewBen],
        chores: [Chore.preview, Chore.preview]
    )
}

