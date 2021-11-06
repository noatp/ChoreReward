//
//  Person.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation

struct User: Identifiable{
    var id: String
    var name: String
    var nickname: String
    var age: Int
    var familyId: String
    var role: Role
    
    static let previewTim = User(
        id: "tim",
        name: "Timothy Tran",
        nickname: "Tim",
        age: 14,
        familyId: "tranfam",
        role: Role.child
    )
    
    static let previewBen = User(
        id: "ben",
        name: "Benjamin Tran",
        nickname: "Ben",
        age: 12,
        familyId: "tranfam",
        role: Role.child
    )
    
    static let previewDavid = User(
        id: "david",
        name: "David Tran",
        nickname: "David",
        age: 42,
        familyId: "tranfam",
        role: Role.parent
    )
}

enum Role{
    case parent
    case child
}
