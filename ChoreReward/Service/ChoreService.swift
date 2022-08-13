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
import SwiftUI

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
            assigner: .init(
                id: currentUserId,
                name: currentUser.name,
                userImageUrl: currentUser.userImageUrl
            ),
            created: Date.now.intTimestamp,
            description: description,
            choreImageUrl: choreImageUrl,
            rewardValue: rewardValueInt
        )
        choreRepository.create(newChore, with: newChoreId, in: currentChoreCollection)
        storageRepository.uploadImage(
            withUrl: choreImageUrl,
            imageType: StorageRepository.ImageType.chore
        ) { [weak self] choreImageUrl, choreImagePath in
            self?.updateChoreImage(for: newChoreId, withImageUrl: choreImageUrl, withImagePath: choreImagePath)
        }
    }

    func takeChore (choreId: String?, currentUser: User?) {
        guard let choreId = choreId,
              let currentUser = currentUser,
              let currentUserId = currentUser.id,
              let currentChoreCollection = currentChoreCollection
        else {
            print("\(#fileID) \(#function): missing choreId and/or currentUser")
            return
        }
        let denormAssignee: DenormUser = .init(
            id: currentUserId,
            name: currentUser.name,
            userImageUrl: currentUser.userImageUrl
        )
        choreRepository.update(choreAtId: choreId, in: currentChoreCollection, withAssignee: denormAssignee)
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
        let choreToDelete = familyChores?.first(where: { chore in
            chore.id == choreId
        })
        if let choreImagePathToDelete = choreToDelete?.choreImagePath {
            storageRepository.deleteImage(withPath: choreImagePathToDelete)
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

    func getChore(withId id: String, completion: @escaping (Chore?) -> Void) {
        if let chore = findInCacheChore(withId: id) {
            completion(chore)
        } else {
            Task {
                let chore = await getSingleChore(withId: id)
                completion(chore)
            }
        }
    }

    private func getChoresOfCurrentFamilyWith(choreCollection: CollectionReference) {
        choreRepository.read(choreCollection)
    }

    private func updateChoreImage(for choreId: String?, withImageUrl imageUrl: String, withImagePath imagePath: String) {
        guard let choreId = choreId, let currentChoreCollection = currentChoreCollection else {
            print("\(#fileID) \(#function): missing choreId or currentChoreCollection")
            return
        }
        choreRepository.update(choreAtId: choreId, in: currentChoreCollection, withImageUrl: imageUrl, withImagePath: imagePath)
    }

    private func findInCacheChore(withId id: String) -> Chore? {
        let chore = familyChores?.first(where: { chore in
            chore.id == id
        })
        return chore
    }

    private func getSingleChore(withId id: String) async -> Chore? {
        guard let currentChoreCollection = currentChoreCollection else {
            return nil
        }
        return await choreRepository.read(choreWithId: id, in: currentChoreCollection)
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
                    if let currentChoreCollection = self?.currentChoreCollection,
                        currentChoreCollection == receivedChoreCollection {
                        print("\(#fileID) \(#function): received-family has same chore collection as in cache "
                              + "-> doing nothing")
                        return
                    } else {
                        print("\(#fileID) \(#function): received-family has diff chore collection from cache "
                              + "-> fetch new chore data")
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
