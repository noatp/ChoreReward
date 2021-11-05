//
//  Person.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation

struct Person: Identifiable{
    var id: String
    var name: String
    var nickname: String
    var age: Int
    var role: Role
    
    static let previewTim = Person(
        id: "tim",
        name: "Timothy Tran",
        nickname: "Tim",
        age: 14,
        role: Role.child
    )
    
    static let previewBen = Person(
        id: "ben",
        name: "Benjamin Tran",
        nickname: "Ben",
        age: 12,
        role: Role.child
    )
    
    static let previewDavid = Person(
        id: "david",
        name: "David Tran",
        nickname: "David",
        age: 42,
        role: Role.parent
    )
}

enum Role{
    case parent
    case child
}
