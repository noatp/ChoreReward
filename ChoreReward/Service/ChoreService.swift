//
//  ChoreService.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import Foundation

class ChoreService{
    private let currentUserRepository: UserRepository
    private let familyRepository: FamilyRepository
    
    init(
        currentUserRepository: UserRepository,
        familyRepository: FamilyRepository
    ) {
        self.currentUserRepository = currentUserRepository
        self.familyRepository = familyRepository
    }
    
    func createChore(
        choreTitle: String
    ){
        guard let currentUserId = currentUserRepository.user?.id,
              let currentFamilyId = currentUserRepository.user?.familyId
        else{
            return
        }
        
        let newChore = Chore(
            title: choreTitle,
            assignerId: currentUserId,
            assigneeId: ""
        )
        let newChoreId = ChoreRepository().createChore(newChore: newChore)
        familyRepository.updateChoreOfFamily(familyId: currentFamilyId, choreId: newChoreId)
    }
    
}
