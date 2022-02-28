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
    private var currentFamilySubscription: AnyCancellable?
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository,
        choreRepository: ChoreRepository
    ) {
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.choreRepository = choreRepository
        addSubscription()
    }
    
    private func addSubscription(){
        currentFamilySubscription = familyRepository.readFamily()
            .sink(receiveValue: { [weak self] receivedFamily in
                print("ChoreSerivce: addSubscription: received new family from FamilyDatabse through FamilyRepository")
                self?.getChoresOfCurrentFamily(currentFamily: receivedFamily)
            })
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
    
    private func getChoresOfCurrentFamily(currentFamily: Family) {
        let choreIds = currentFamily.chores
        guard choreIds.count > 0, choreIds.count < 10 else{
            return
        }
        Task{
            choreList = await choreRepository.readMultipleChores(choreIds: choreIds) ?? []
        }
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
