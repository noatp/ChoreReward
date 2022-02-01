//
//  ChoreService.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import Foundation
import Combine

class ChoreService: ObservableObject{
    @Published var choreList: [Chore] = []
    
    private let userRepository: UserRepository
    private let familyRepository: FamilyRepository
    private let choreRepository: ChoreRepository
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository,
        choreRepository: ChoreRepository
    ) {
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.choreRepository = choreRepository
    }
    
//    func addSubscription(){
//        currentFamilySubscription = currentFamilyRepository.$family
//            .sink(receiveValue: { [weak self] receivedFamily in
//                guard let currentFamily = receivedFamily else{
//                    return
//                }
//                self?.getChoresOfCurrentFamily(currentFamily: currentFamily)
//            })
//        choreListSubscription = currentChoreRepository.$choreList
//            .sink(receiveValue: { [weak self] receivedChoreList in
//                self?.choreList = receivedChoreList
//            })
//    }
    
    func createChore(choreTitle: String, currentUser: User) async {
        guard let currentUserId = currentUser.id,
              let currentFamilyId = currentUser.familyId
        else{
            return
        }
        
        let newChore = Chore(
            title: choreTitle,
            assignerId: currentUserId,
            assigneeId: "",
            completed: false
        )
        let newChoreId = ChoreRepository().createChore(newChore: newChore)
        await familyRepository.updateChoreOfFamily(familyId: currentFamilyId, choreId: newChoreId)
    }
    
    func getChoresOfCurrentFamily(currentFamily: Family) async {
        let choreIds = currentFamily.chores
        guard choreIds.count > 0, choreIds.count < 10 else{
            return
        }
        
        //        choreList = await choreRepository.readMultipleChores(choreIds: currentFamily.chores) ?? []
    }
    
    
    func resetCache(){
        choreList = []
    }
}
