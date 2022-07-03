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
    private var currentChoreCollection: CollectionReference?

    private let familyRepository: FamilyRepository
    private let choreRepository: ChoreRepository
    private let storageRepository: StorageRepository

    private var currentFamilySubscription: AnyCancellable?
    private var familyChoresSubscription: AnyCancellable?

    init(
        familyRepository: FamilyRepository,
        choreRepository: ChoreRepository,
        storageRepository: StorageRepository
    ) {
        self.familyRepository = familyRepository
        self.choreRepository = choreRepository
        self.storageRepository = storageRepository
        addSubscription()
    }

    func createChore(
        withTitle title: String,
        withDescription description: String,
        withImageUrl choreImageUrl: String,
        withRewardValue rewardValue: String,
        byUser currentUser: User) {
        guard let currentUserId = currentUser.id,
              let currentChoreCollection = currentChoreCollection,
              let rewardValueInt = Int(rewardValue),
              currentUser.role != .child
        else {
            return
        }

        let newChoreId = UUID().uuidString
        let newChore = Chore(
            title: title,
            assignerId: currentUserId,
            created: Date.now.intTimestamp,
            description: description,
            choreImageUrl: choreImageUrl,
            rewardValue: rewardValueInt
        )
        choreRepository.create(newChore, with: newChoreId, in: currentChoreCollection)
        storageRepository.uploadChoreImage(with: choreImageUrl) { [weak self] newChoreImageUrl in
            self?.updateChoreImage(for: newChoreId, with: newChoreImageUrl)
        }
    }

    func takeChore (choreId: String?, currentUserId: String?) {
        guard let choreId = choreId,
              let currentUserId = currentUserId,
              let currentChoreCollection = currentChoreCollection
        else {
            print("\(#fileID) \(#function): missing choreId and/or currentUserId")
            return
        }
        choreRepository.update(choreAtId: choreId, in: currentChoreCollection, withAssigneeId: currentUserId)
    }

    func completeChore (choreId: String?) {
        guard let choreId = choreId,
              let currentChoreCollection = currentChoreCollection
        else {
            print("\(#fileID) \(#function): missing choreId")
            return
        }
        choreRepository.update(finishedTimestampForChoreAtId: choreId, in: currentChoreCollection)
    }

    func delete (choreAtId choreId: String?, byUser currentUser: User) {
        guard let choreId = choreId,
              let currentChoreCollection = currentChoreCollection,
              currentUser.role != .child
        else {
            return
        }
        choreRepository.delete(choreAtId: choreId, in: currentChoreCollection)

    }

    func refreshChoreList() {
        guard let currentChoreCollection = currentChoreCollection else {
            print("\(#fileID) \(#function): tryin to refresh chores data, but currentChoreCollection is nil")
            return
        }
        getChoresOfCurrentFamilyWith(choreCollection: currentChoreCollection)
    }

    private func getChoresOfCurrentFamilyWith(choreCollection: CollectionReference) {
        choreRepository.read(choreCollection)
    }

    private func updateChoreImage(for choreId: String?, with imageUrl: String) {
        guard let choreId = choreId, let currentChoreCollection = currentChoreCollection else {
            print("\(#fileID) \(#function): missing choreId or currentChoreCollection")
            return
        }
        choreRepository.update(choreAtId: choreId, in: currentChoreCollection, withImageUrl: imageUrl)
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
                        self?.reset()
                        self?.currentChoreCollection = receivedChoreCollection
                        self?.getChoresOfCurrentFamilyWith(choreCollection: receivedChoreCollection)
                        return
                    }
                } else {
                    print("\(#fileID) \(#function): received reset signal from FamilyRepository, reset chore service")
                    self?.reset()
                    return
                }
            })
    }

    private func reset() {
        familyChores = []
        currentChoreCollection = nil
        choreRepository.reset()
    }
}
