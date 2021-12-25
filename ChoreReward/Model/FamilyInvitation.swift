//
//  FamilyInvitation.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/25/21.
//

import Foundation
import FirebaseFirestoreSwift

struct FamilyInvitation: Identifiable, Codable{
    @DocumentID var id: String? // this is also the id of the invitee
    var inviter: String
    var toJoinFamily: String
    
    static let preview = FamilyInvitation(
        id: User.previewTim.id!,
        inviter: User.previewDavid.id!,
        toJoinFamily: Family.preview.id!
    )
}
