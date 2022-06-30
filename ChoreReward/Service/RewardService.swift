//
//  RewardService.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import Foundation
import Combine
import FirebaseFirestore

class RewardService: ObservableObject {
    @Published var userRewards: [Reward]?
    @Published var userBalance: Int?
    private var rewardCollection: CollectionReference?

    private let userRepository: UserRepository
    private let rewardRepository: RewardRepository

    private var currentUserSubscription: AnyCancellable?
    private var userRewardSubscription: AnyCancellable?

    init(
        userRepository: UserRepository,
        rewardRepository: RewardRepository
    ) {
        self.userRepository = userRepository
        self.rewardRepository = rewardRepository
        addSubscription()
    }

    func createReward(withName name: String, andValue value: Int) {
        guard let currentRewardCollection = rewardCollection else {
            return
        }

        let newReward = Reward(
            name: name,
            value: value
        )
        rewardRepository.create(newReward, in: currentRewardCollection)

    }

    private func getRewardsOf(rewardCollection: CollectionReference) {
        rewardRepository.read(rewardCollection)
    }

    private func addSubscription() {
        userRewardSubscription = rewardRepository.userRewardsPublisher
            .sink(receiveValue: { [weak self] receivedUserRewards in
                guard let userRewards = receivedUserRewards else {
                    return
                }
                self?.userRewards = userRewards
                print("\(#fileID) \(#function): received and cached a non-nil reward list")
            })
        currentUserSubscription = userRepository.userPublisher
            .sink(receiveValue: { [weak self] receivedUser in
                if let receivedUser = receivedUser {
                    print("\(#fileID) \(#function): received a non-nil user, updating cache user balance, and checking for reward collection ref")
                    self?.userBalance = receivedUser.balance
                    guard let receivedRewardCollection = receivedUser.rewardCollection else {
                        print("\(#fileID) \(#function): received user does not have a reward collection")
                        self?.userRewards = []
                        return
                    }

                    if let rewardCollectionInCache = self?.rewardCollection, receivedRewardCollection == rewardCollectionInCache {
                        print("\(#fileID) \(#function): received-family has same reward collection as the cached reward collection -> doing nothing")
                        return
                    } else {
                        print("\(#fileID) \(#function): received-family has diff reward collection from the cached reward collection -> resetting reward service & fetch new reward data")
                        self?.reset()
                        self?.rewardCollection = receivedRewardCollection
                        self?.getRewardsOf(rewardCollection: receivedRewardCollection)
                        return
                    }
                } else {
                    print("\(#fileID) \(#function): received reset signal from UserRepository, reset reward service")
                    self?.reset()
                    return
                }
            })
    }

    private func reset() {
        userRewards = []
        rewardCollection = nil
        rewardRepository.reset()
    }
}
