//
//  Family.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/5/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Family: Identifiable, Codable{
    @DocumentID var id: String?
    var admin: String //store the uid of the family creator
    var members: [String]
    var chores: [String]
    
    static let preview = Family(
        id: "tranfam",
        admin: User.previewDavid.id!,
        members: [User.previewDavid.id!, User.previewTim.id!, User.previewBen.id!],
        chores: [Chore.preview.id!, Chore.preview.id!]
    )
}

