//
//  FamilyInvitation.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/25/21.
//

import Foundation
import FirebaseFirestoreSwift

struct FamilyInvitation: Identifiable, Codable{
    @DocumentID var id: String?
    var inviter: String
    var invitee: String
    var toJoinFamily: String
    
    static let preview = FamilyInvitation(
        id: "preview",
        inviter: User.previewDavid.id!,
        invitee: User.previewTim.id!,
        toJoinFamily: Family.preview.id!
    )
}
