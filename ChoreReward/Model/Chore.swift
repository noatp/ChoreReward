//
//  Chore.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Chore: Identifiable, Codable{
    @DocumentID var id: String?
    var title: String
    var assignerId: String
    var assigneeId: String
    
    static let preview = Chore(
        id: UUID().uuidString,
        title: "Wash the dishes",
        assignerId: User.previewDavid.id!,
        assigneeId: User.previewTim.id!
    )
    
    enum RewardType: String, CaseIterable, Identifiable{
        case goal
        case monetary
        
        var id: String {self.rawValue}
    }
}



