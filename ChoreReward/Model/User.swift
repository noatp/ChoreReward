//
//  Person.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable{
    @DocumentID public var id: String?
    var email: String
    var name: String
    var role: Role
    
    static let previewTim = User(
        id: "tim",
        email: "test@gmail.com",
        name: "Timothy Tran",
        role: .child
    )
    
    static let previewBen = User(
        id: "ben",
        email: "test1@gmail.com",
        name: "Benjamin Tran",
        role: .child
    )
    
    static let previewDavid = User(
        id: "david",
        email: "test2@gmail.com",
        name: "David Tran",
        role: .parent
    )
}

enum Role: String, Codable{
    case parent
    case child
}
