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
    var members: [String]
    var chores: [String]
    
    static let preview = Family(
        id: "tranfam",
        members: [User.previewDavid.id!, User.previewTim.id!, User.previewBen.id!],
        chores: [Chore.preview.id, Chore.preview.id]
    )
}

