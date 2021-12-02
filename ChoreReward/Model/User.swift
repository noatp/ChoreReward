//
//  Person.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable{
    @DocumentID var id: String?
    var email: String
    var name: String
    
    static let previewTim = User(
        id: "tim",
        email: "test@gmail.com",
        name: "Timothy Tran"
    )
    
    static let previewBen = User(
        id: "ben",
        email: "test1@gmail.com",
        name: "Benjamin Tran"
    )
    
    static let previewDavid = User(
        id: "david",
        email: "test2@gmail.com",
        name: "David Tran"
    )
}

enum Role{
    case parent
    case child
}
