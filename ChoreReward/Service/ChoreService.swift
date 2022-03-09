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
                guard let currentFamily = receivedFamily else{
                    self?.resetService()
                    return
                }
                print("ChoreSerivce: addSubscription: received new family from FamilyDatabse through FamilyRepository")
                self?.getChoresOfCurrentFamily(currentFamily: currentFamily)
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
            created: Date()
            
        )
        let newChoreId = ChoreRepository().createChore(newChore: newChore)
        await familyRepository.updateChoreOfFamily(familyId: currentFamilyId, choreId: newChoreId)
    }
    
    private func getChoresOfCurrentFamily(currentFamily: Family) {
        choreList = []
        var choreIds = currentFamily.chores
        while (!choreIds.isEmpty){
            let batchSize = (choreIds.count > 10) ? 10 : choreIds.count
            let idBatch = Array(choreIds[0...(batchSize - 1)])
            choreIds = Array(choreIds.dropFirst(batchSize))
            Task{
                choreList += await choreRepository.readMultipleChores(choreIds: idBatch) ?? []
                print("HERE \(batchSize)")
            }
        }
    }
    
    func readChore (choreId: String) -> Chore{
        return choreList.first { chore in
            chore.id == choreId
        }!
    }
    
    func takeChore (choreId: String?, currentUserId: String?){
        guard let choreId = choreId,
              let currentUserId = currentUserId else{
                  print("ChoreService: takeChore: missing choreId and/or currentUserId")
                  return
              }
        Task{
            await choreRepository.updateAssigneeForChore(choreId: choreId, assigneeId: currentUserId)
            await readUpdatedChore(choreId: choreId)
        }
    }
    
    func completeChore (choreId: String?){
        guard let choreId = choreId else{
            print("ChoreService: completeChore: missing choreId")
            return
        }
        Task{
            await choreRepository.updateCompletionForChore(choreId: choreId)
            await readUpdatedChore(choreId: choreId)
        }
    }
    
    private func readUpdatedChore(choreId: String) async {
        let choreIndex = choreList.firstIndex { chore in
            chore.id == choreId
        }
        guard let choreIndex = choreIndex else{
            print("ChoreService: takeChore: could not find chore with provided choreId in choreList")
            return
        }
        let updatedChore = await choreRepository.readChore(choreId: choreId)
        guard let updatedChore = updatedChore else{
            print("ChoreService: takeChore: could not find chore with provided choreId after update")
            return
        }
        choreList[choreIndex] = updatedChore
    }
    
    private func resetService(){
        choreList = []
    }
}
