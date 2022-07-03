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
    var assigneeId: String?
    var finished: Int?
    var created: Int
    var description: String
    var choreImageUrl: String
    var rewardValue: Int?

    static let empty = Chore(
        id: "",
        title: "",
        assignerId: "",
        assigneeId: "",
        created: 0,
        description: "",
        choreImageUrl: ""
    )

    static let previewChoreFinished = Chore(
        id: "id",
        title: "Wash the dishes",
        assignerId: "preview assignerId",
        assigneeId: "preview assigneeId",
        finished: Date.now.intTimestamp,
        created: Date.now.intTimestamp,
        description: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum \
                posuere lorem ipsum dolor sit amet consectetur. Amet consectetur adipiscing \
                elit pellentesque. Id venenatis a con
            """,
        choreImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvaNbNa9E_46fY75AFA9N8dhocKjEdDegvrN5QbBHH-WX-oij4xtjeYijvpC_kHB9-FiU&usqp=CAU"
    )

    static let previewChoreFinished_1 = Chore(
        id: "id_1",
        title: "Wash the dishes",
        assignerId: "preview assignerId",
        assigneeId: "preview assigneeId",
        finished: Date.now.intTimestamp,
        created: Date.now.intTimestamp,
        description: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum \
                posuere lorem ipsum dolor sit amet consectetur. Amet consectetur adipiscing \
                elit pellentesque. Id venenatis a con
            """,
        choreImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvaNbNa9E_46fY75AFA9N8dhocKjEdDegvrN5QbBHH-WX-oij4xtjeYijvpC_kHB9-FiU&usqp=CAU"
    )

    static let previewChoreUnfinished = Chore(
        id: "id_2",
        title: "Wash the dishes",
        assignerId: "preview assignerId",
        assigneeId: "preview assigneeId",
        created: Date.now.intTimestamp,
        description: """
                Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Interdum \
                posuere lorem ipsum dolor sit amet consectetur. Amet consectetur adipiscing \
                elit pellentesque. Id venenatis a con
            """,
        choreImageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvaNbNa9E_46fY75AFA9N8dhocKjEdDegvrN5QbBHH-WX-oij4xtjeYijvpC_kHB9-FiU&usqp=CAU"
    )
}
