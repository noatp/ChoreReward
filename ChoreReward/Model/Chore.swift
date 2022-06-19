//
//  Chore.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chore: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var assignerId: String
    var assigneeId: String
    var completed: Int?
    var created: Int
    var description: String
    var choreImageUrl: String
    var rewardValue: Float?

    static let empty = Chore(
        id: "",
        title: "",
        assignerId: "",
        assigneeId: "",
        created: 0,
        description: "",
        choreImageUrl: ""
    )
}
