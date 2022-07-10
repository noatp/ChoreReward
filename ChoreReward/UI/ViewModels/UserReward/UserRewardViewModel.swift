//
//  UserGoalViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import Foundation
import Combine

class UserRewardViewModel: StatefulViewModel {
    @Published var _state: UserRewardViewState?
    var viewState: AnyPublisher<UserRewardViewState?, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private let rewardService: RewardService
    private var userRewardsSubscription: AnyCancellable?
    private var userBalanceSubscription: AnyCancellable?

    init(
        userService: UserService,
        rewardService: RewardService
    ) {
        self.userService = userService
        self.rewardService = rewardService
        self.addSubscription()
    }

    private func addSubscription() {
        userRewardsSubscription = rewardService.$userRewards
            .sink(receiveValue: { [weak self] receivedRewards in
                guard let receivedRewards = receivedRewards else {
                    return
                }
                if let oldState = self?._state {
                    self?._state = .init(rewards: receivedRewards, balance: oldState.balance)
                } else {
                    self?._state = .init(rewards: receivedRewards, balance: 0)
                }
            })
        userBalanceSubscription = rewardService.$userBalance
            .sink(receiveValue: { [weak self] receivedBalance in
                guard let receivedBalance = receivedBalance else {
                    return
                }
                if let oldState = self?._state {
                    self?._state = .init(rewards: oldState.rewards, balance: receivedBalance)
                } else {
                    self?._state = .init(rewards: [], balance: receivedBalance)
                }
            })
    }

    func performAction(_ action: UserRewardViewAction) {}
}

struct UserRewardViewState {
    let rewards: [Reward]
    let balance: Int
    static let preview: UserRewardViewState = .init(rewards: [], balance: 0)
}

enum UserRewardViewAction {
}

extension Dependency.ViewModels {
    var userGoalViewModel: UserRewardViewModel {
        UserRewardViewModel(
            userService: services.userService,
            rewardService: services.rewardService
        )
    }
}
