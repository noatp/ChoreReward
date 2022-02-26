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
    @Published var chore: Chore? = nil
    
    private let userRepository: UserRepository
    private let familyRepository: FamilyRepository
    private let choreRepository: ChoreRepository
    
    private var choreSubscription: AnyCancellable?
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository,
        choreRepository: ChoreRepository
    ) {
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.choreRepository = choreRepository
    }
    
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
        
        choreList = await choreRepository.readMultipleChores(choreIds: choreIds) ?? []
    }
    
    func readChore(choreId: String) {
        choreSubscription = choreRepository.readChore(choreId: choreId)
            .sink(receiveValue: { [weak self] receivedChore in
                print("ChoreService: readChore: received new chore")
                self?.chore = receivedChore
            })
    }
    
    func resetCache(){
        choreList = []
    }
}
