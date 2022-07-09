//
//  UserGoalViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import Foundation
import Combine

class UserRewardViewModel: StatefulViewModel {
    @Published var _state: UserRewardViewState = empty
    static let empty = UserRewardViewState.empty
    var viewState: AnyPublisher<UserRewardViewState, Never> {
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
                guard let oldState = self?._state,
                      let rewards = receivedRewards
                else {
                    return
                }
                self?._state = .init(rewards: rewards, balance: oldState.balance)
            })
        userBalanceSubscription = rewardService.$userBalance
            .sink(receiveValue: { [weak self] receivedBalance in
                guard let oldState = self?._state,
                      let balance = receivedBalance
                else {
                    return
                }
                self?._state = .init(rewards: oldState.rewards, balance: balance)
            })
    }

    func performAction(_ action: UserRewardViewAction) {
    }
}

struct UserRewardViewState {
    let rewards: [Reward]
    let balance: Int

    static let empty: UserRewardViewState = .init(rewards: [], balance: 0)
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
