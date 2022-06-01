//
//  ChoreService.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import Foundation
import Combine
import UIKit
import FirebaseFirestore

class ChoreService: ObservableObject {
    @Published var familyChores: [Chore]?
    @Published var isBusy: Bool = false

    private let userRepository: UserRepository
    private let familyRepository: FamilyRepository
    private let choreRepository: ChoreRepository
    private let storageRepository: StorageRepository

    private var currentFamilySubscription: AnyCancellable?
    private var familyChoresSubscription: AnyCancellable?

    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository,
        choreRepository: ChoreRepository,
        storageRepository: StorageRepository
    ) {
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.choreRepository = choreRepository
        self.storageRepository = storageRepository
        addSubscription()
    }

    private func addSubscription() {
        currentFamilySubscription = familyRepository.readFamily()
            .sink(receiveValue: { [weak self] receivedFamily in
                guard let currentFamily = receivedFamily else {
                    self?.resetService()
                    return
                }
                print("\(#fileID) \(#function): received new family from FamilyDatabse through FamilyRepository")
                self?.getChoresOfCurrentFamily(currentFamily: currentFamily)
            })
    }

    func createChore(choreTitle: String, choreDescription: String, currentUser: User, choreImage: UIImage) async {
        isBusy = true
        guard let currentUserId = currentUser.id else {
            return
        }

        let newChoreId = UUID().uuidString

        Task {
            let choreImageUrl = await storageRepository.uploadChoreImage(image: choreImage, choreId: newChoreId)

            guard let choreImageUrl = choreImageUrl else {
                print("\(#fileID) \(#function): could not get a url for the chore image")
                return
            }

            let newChore = Chore(
                title: choreTitle,
                assignerId: currentUserId,
                assigneeId: "",
                description: choreDescription,
                choreImageUrl: choreImageUrl
            )

            choreRepository.createChore(newChore: newChore, newChoreId: newChoreId)
            isBusy = false
        }
    }

    private func getChoresOfCurrentFamily(currentFamily: Family) {
        familyChoresSubscription = choreRepository.familyChoresPublisher
            .sink(receiveValue: { [weak self] receivedFamilyChores in
                self?.familyChores = receivedFamilyChores
            })
        choreRepository.readChoresOfFamily(currentFamily)
    }

    func takeChore (choreId: String?, currentUserId: String?) {
        guard let choreId = choreId,
              let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): missing choreId and/or currentUserId")
                  return
              }
        Task {
            await choreRepository.updateAssigneeForChore(choreId: choreId, assigneeId: currentUserId)
//            await readUpdatedChore(choreId: choreId)
        }
    }

    func completeChore (choreId: String?) {
        guard let choreId = choreId else {
            print("\(#fileID) \(#function): missing choreId")
            return
        }
        Task {
            await choreRepository.updateCompletionForChore(choreId: choreId)
//            await readUpdatedChore(choreId: choreId)
        }
    }

//    private func readUpdatedChore(choreId: String) async {
//        let choreIndex = familyChores.firstIndex { chore in
//            chore.id == choreId
//        }
//        guard let choreIndex = choreIndex else{
//            print("\(#fileID) \(#function): could not find chore with provided choreId in choreList")
//            return
//        }
//        let updatedChore = await choreRepository.readChore(choreId: choreId)
//        guard let updatedChore = updatedChore else{
//            print("\(#fileID) \(#function): could not find chore with provided choreId after update")
//            return
//        }
//        familyChores[choreIndex] = updatedChore
//    }

    private func resetService() {
        familyChores = []
    }
}
