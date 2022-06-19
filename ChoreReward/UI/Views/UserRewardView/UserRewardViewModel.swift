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
    var state: AnyPublisher<UserRewardViewState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private let rewardService: RewardService
    private var userRewardsSubscription: AnyCancellable?

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
                guard let rewards = receivedRewards else {
                    return
                }
                self?._state = .init(rewards: rewards)
            })
    }

    private func addNewReward(name: String, value: String) {
        guard let floatValue = Float(value) else {
            return
        }
        rewardService.createReward(withName: name, andValue: floatValue)
    }

    func performAction(_ action: UserRewardViewAction) {
        switch action {
        case.addNewReward(let name, let value):
            addNewReward(name: name, value: value)
        }
    }
}

struct UserRewardViewState {
    let rewards: [Reward]

    static let empty: UserRewardViewState = .init(rewards: [])
}

enum UserRewardViewAction {
    case addNewReward(name: String, value: String)
}

extension Dependency.ViewModels {
    var userGoalViewModel: UserRewardViewModel {
        UserRewardViewModel(
            userService: services.userService,
            rewardService: services.rewardService
        )
    }
}
