//
//  Family.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/5/21.
//

import Foundation

struct Family: Identifiable{
    var id: String
    var member: [Person]
    var admin: [Person]
    var parents: [Person]
    var children: [Person]
    
    static let preview = Family(
        id: "tranfam",
        member: [Person.previewDavid, Person.previewTim, Person.previewBen],
        admin: [Person.previewDavid],
        parents: [Person.previewDavid],
        children: [Person.previewBen, Person.previewTim]
    )
}

