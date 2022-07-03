//
//  Family.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/5/21.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Family: Identifiable, Codable {
    @DocumentID var id: String?
    var familyDocRef: DocumentReference?
    var adminId: String // store the uid of the family creator
    var members: [DenormUser]
    var chores: [DenormChore]?

    static let preview = Family(
        id: "tranfam",
        adminId: User.preview.id ?? "",
        members: [DenormUser.preview]
    )
}

extension Family {
    var choreCollection: CollectionReference? {
        return familyDocRef?.collection("chores")
    }
}

struct DenormUser: Codable, Identifiable {
    let id: String
    let name: String?
    let userImageUrl: String?

    static let preview: DenormUser = .init(
        id: "user_id",
        name: "John Doe",
        userImageUrl: "preview_denorm_user_url"
    )
}

struct DenormChore: Codable, Identifiable {
    let id: String
    let title: String
    let choreImageUrl: String
    let assigneeId: String?
    let finished: Bool
    let value: Int

    static let preview: DenormChore = .init(
        id: "chore_id",
        title: "Wash the dishes. Then wash it again. Then wash it once again. Then wash it once again. Then wash it once again.",
        choreImageUrl: "preview_denorm_chore_url",
        assigneeId: nil,
        finished: false,
        value: 12
    )
}
