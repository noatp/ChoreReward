//
//  Person.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

struct User: Identifiable, Codable {
    @DocumentID public var id: String?
    var email: String
    var name: String
    var role: Role
    var familyId: String?
    var profileImageUrl: String?

    static let preview = User(
        id: "previewID",
        email: "preview@gmail.com",
        name: "Preview name",
        role: .parent,
        familyId: nil,
        profileImageUrl: nil
    )

    static let empty = User(email: "", name: "", role: .child)
}

enum Role: String, Codable {
    case parent
    case child
    case admin
}
