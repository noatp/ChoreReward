//
//  Family.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/5/21.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct Family: Identifiable, Codable{
    @DocumentID var id: String?
    var familyDocRef: DocumentReference?
    var adminId: String //store the uid of the family creator
    var members: [DenormUser]
    
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
    let name: String
    let profileImageUrl: String?
    
    static let preview: DenormUser = .init(
        id: "preview_denorm_user_id",
        name: "preview_denorm_user_name",
        profileImageUrl: "preview_denorm_user_url"
    )
}

