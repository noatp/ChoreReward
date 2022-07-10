//
//  GoalRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class RewardRepository: ObservableObject {
    private let database = Firestore.firestore()
    private var userRewardsListener: ListenerRegistration?
    let userRewardsPublisher = PassthroughSubject<[Reward]?, Never>()

    func create(_ newReward: Reward, in rewardCollection: CollectionReference) {
        do {
            _ = try rewardCollection.addDocument(from: newReward)
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func read(_ rewardCollection: CollectionReference) {
        if userRewardsListener == nil {
            userRewardsListener = rewardCollection.addSnapshotListener { [weak self] querySnapshot, error in
                guard let querySnapshot = querySnapshot else {
                    print("\(#fileID) \(#function): Error fetching documents: \(error!)")
                    return
                }
                let rewards: [Reward] = querySnapshot.documents
                    .compactMap { document in
                        do {
                            return try document.data(as: Reward.self)
                        } catch {
                            print("\(#fileID) \(#function): error")
                            return nil
                        }
                    }
                if rewards.isEmpty {
                    print("\(#fileID) \(#function): received empty list, publishing empty list...")
                    self?.userRewardsPublisher.send([])
                } else {
                    print("\(#fileID) \(#function): received rewards data, publishing...")
                    self?.userRewardsPublisher.send(rewards)
                }
            }
        }
    }

    func reset() {
        self.userRewardsPublisher.send(nil)
        self.userRewardsListener?.remove()
        self.userRewardsListener = nil
    }
}
