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
    var assigner: DenormUser
    var assignee: DenormUser?
    var finished: Int?
    var created: Int
    var description: String
    var choreImageUrl: String
    var choreImagePath: String?
    var rewardValue: Int

    static let empty = Chore(
        id: "",
        title: "",
        assigner: .empty,
        assignee: .empty,
        created: 0,
        description: "",
        choreImageUrl: "",
        rewardValue: 0
    )

    static let previewChoreFinished = Chore(
        id: "id",
        title: "Wash the dishes",
        assigner: .preview,
        assignee: .preview,
        finished: 1661206155,
        created: 1661058434,
        description: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum \
                posuere lorem ipsum dolor sit amet consectetur. Amet consectetur adipiscing \
                elit pellentesque. Id venenatis a con
            """,
        choreImageUrl: "https://nolisoli.ph/wp-content/uploads/2020/10/pexels-cottonbro-4108715.jpg",
        rewardValue: 12
    )

    static let previewChoreFinished_1 = Chore(
        id: "id_1",
        title: "Wash the dishes",
        assigner: .preview,
        assignee: .preview,
        finished: 1661206183,
        created: 1661058434,
        description: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum \
                posuere lorem ipsum dolor sit amet consectetur. Amet consectetur adipiscing \
                elit pellentesque. Id venenatis a con
            """,
        choreImageUrl: "https://nolisoli.ph/wp-content/uploads/2020/10/pexels-cottonbro-4108715.jpg",
        rewardValue: 12
    )

    static let previewUnassignedChore = Chore(
        title: "Wash the dishes",
        assigner: .preview,
        created: 1661208868,
        description: "A short description of the chore. This should be a relatively easy chore.",
        choreImageUrl: "https://nolisoli.ph/wp-content/uploads/2020/10/pexels-cottonbro-4108715.jpg",
        rewardValue: 12)

    static let previewChoreUnfinished = Chore(
        id: "id_2",
        title: "Wash the dishes",
        assigner: .preview,
        assignee: .preview,
        created: 1661058434,
        description: "A short description of the chore. This should be a relatively easy chore.",
        choreImageUrl: "https://nolisoli.ph/wp-content/uploads/2020/10/pexels-cottonbro-4108715.jpg",
        rewardValue: 12
    )
}
