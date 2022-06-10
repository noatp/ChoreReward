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
    private var currentChoreCollection: CollectionReference?

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

    func createChore(choreTitle: String, choreDescription: String, currentUser: User, choreImageUrl: String) {
        isBusy = true
        guard let currentUserId = currentUser.id, let currentChoreCollection = currentChoreCollection else {
            return
        }

        let newChoreId = UUID().uuidString

        let newChore = Chore(
            title: choreTitle,
            assignerId: currentUserId,
            assigneeId: "",
            created: Date.now.intTimestamp,
            description: choreDescription,
            choreImageUrl: choreImageUrl
        )
        choreRepository.create(newChore, with: newChoreId, in: currentChoreCollection)
        storageRepository.uploadChoreImage(with: choreImageUrl) { [weak self] newChoreImageUrl in
            self?.updateChoreImage(for: newChoreId, with: newChoreImageUrl)
        }
        isBusy = false
    }

    func takeChore (choreId: String?, currentUserId: String?) {
        guard let choreId = choreId,
              let currentUserId = currentUserId,
              let currentChoreCollection = currentChoreCollection
        else {
            print("\(#fileID) \(#function): missing choreId and/or currentUserId")
            return
        }
        choreRepository.updateAssigneeForChore(choreId: choreId, assigneeId: currentUserId, choreCollection: currentChoreCollection)
    }

    func completeChore (choreId: String?) {
        guard let choreId = choreId,
              let currentChoreCollection = currentChoreCollection
        else {
            print("\(#fileID) \(#function): missing choreId")
            return
        }
        choreRepository.updateCompletionForChore(choreId: choreId, choreCollection: currentChoreCollection)
    }

    private func getChoresOfCurrentFamilyWith(choreCollection: CollectionReference) {
        choreRepository.readChoreCollection(choreCollection)
    }

    private func updateChoreImage(for choreId: String?, with imageUrl: String) {
        guard let choreId = choreId, let currentChoreCollection = currentChoreCollection else {
            print("\(#fileID) \(#function): missing choreId or currentChoreCollection")
            return
        }
        choreRepository.updateChoreImage(for: choreId, in: currentChoreCollection, with: imageUrl)
    }

    private func addSubscription() {
        familyChoresSubscription = choreRepository.familyChoresPublisher
            .sink(receiveValue: { [weak self] receivedFamilyChores in
                guard let familyChores = receivedFamilyChores else {
                    return
                }
                self?.familyChores = familyChores
                print("\(#fileID) \(#function): received and cached a non-nil chore list")
            })
        currentFamilySubscription = familyRepository.familyPublisher
            .sink(receiveValue: { [weak self] receivedFamily in
                if let currentFamily = receivedFamily {
                    print("\(#fileID) \(#function): received a non-nil family, checking for chore collection ref")
                    guard let receivedChoreCollection = currentFamily.choreCollection else {
                        print("\(#fileID) \(#function): received family does not have a chore collection")
                        self?.familyChores = []
                        return
                    }
                    if let currentChoreCollection = self?.currentChoreCollection, currentChoreCollection == receivedChoreCollection {
                        print("\(#fileID) \(#function): received-family has same chore collection as the cached chore collection -> doing nothing")
                        return
                    } else {
                        print("\(#fileID) \(#function): received-family has diff chore collection from the cached family -> resetting chore service & fetch new chore data")
                        self?.resetService()
                        self?.currentChoreCollection = receivedChoreCollection
                        self?.getChoresOfCurrentFamilyWith(choreCollection: receivedChoreCollection)
                        return
                    }
                } else {
                    print("\(#fileID) \(#function): received reset signal from FamilyRepository, reset chore service")
                    self?.resetService()
                    return
                }
            })
    }

    private func resetService() {
        familyChores = []
        currentChoreCollection = nil
        choreRepository.resetRepository()
    }
}
