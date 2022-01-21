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
    
    private let currentUserRepository: UserRepository
    private let currentFamilyRepository: FamilyRepository
    private let currentChoreRepository: ChoreRepository
    
    private var currentFamilySubscription: AnyCancellable?
    private var choreListSubscription: AnyCancellable?
    
    init(
        currentUserRepository: UserRepository,
        currentFamilyRepository: FamilyRepository,
        currentChoreRepository: ChoreRepository
    ) {
        self.currentUserRepository = currentUserRepository
        self.currentFamilyRepository = currentFamilyRepository
        self.currentChoreRepository = currentChoreRepository
        addSubscription()
    }
    
    func addSubscription(){
        currentFamilySubscription = currentFamilyRepository.$family
            .sink(receiveValue: { [weak self] receivedFamily in
                guard let currentFamily = receivedFamily else{
                    return
                }
                self?.getChoresOfCurrentFamily(currentFamily: currentFamily)
            })
        choreListSubscription = currentChoreRepository.$choreList
            .sink(receiveValue: { [weak self] receivedChoreList in
                self?.choreList = receivedChoreList
            })
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
        currentFamilyRepository.updateChoreOfFamily(familyId: currentFamilyId, choreId: newChoreId)
    }
    
    func getChoresOfCurrentFamily(currentFamily: Family){
        currentChoreRepository.readMultipleChores(choreIds: currentFamily.chores)
    }
    
}
