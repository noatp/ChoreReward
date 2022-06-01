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
    var completed: Date?
    @ServerTimestamp var created: Timestamp?
    var description: String
    var choreImageUrl: String

    static let empty = Chore(
        id: "",
        title: "",
        assignerId: "",
        assigneeId: "",
        created: Timestamp.init(),
        description: "",
        choreImageUrl: ""
    )

    enum RewardType: String, CaseIterable, Identifiable {
        case goal
        case monetary

        var id: String {self.rawValue}
    }
}
