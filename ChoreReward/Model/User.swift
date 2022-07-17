//
//  Person.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID public var id: String?
    var email: String
    var name: String
    var role: Role
    var familyId: String?
    var userImageUrl: String?
    var balance: Int?
    var userDocRef: DocumentReference?
    var fcmToken: String?

    static let preview = User(
        id: "previewID",
        email: "preview@gmail.com",
        name: "Preview name",
        role: .parent,
        familyId: nil,
        userImageUrl: nil
    )

    static let empty = User(email: "", name: "", role: .child)
}

extension User {
    var rewardCollection: CollectionReference? {
        return userDocRef?.collection("rewards")
    }
//    var roundedBalance: Float? {
//        return balance == nil ? nil : (round(balance! * 100) / 100.0)
//    }
}

enum Role: String, Codable {
    case parent
    case child
    case admin
}
