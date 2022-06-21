//
//  AddUserRewardViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/20/22.
//

import Foundation
import Combine

class AddUserRewardViewModel: StatefulViewModel {
    @Published var _state: AddUserRewardState = empty
    static let empty = AddUserRewardState.empty
    var state: AnyPublisher<AddUserRewardState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let rewardService: RewardService

    init(
        rewardService: RewardService
    ) {
        self.rewardService = rewardService
    }

    private func addNewReward(name: String, value: String) {
        guard let floatValue = Float(value) else {
            return
        }
        rewardService.createReward(withName: name, andValue: floatValue)
    }

    func performAction(_ action: AddUserRewardAction) {
        switch action {
        case.addNewReward(let name, let value):
            addNewReward(name: name, value: value)
        }
    }

}

struct AddUserRewardState {
    static let empty: AddUserRewardState = .init(
    )
}

enum AddUserRewardAction {
    case addNewReward(name: String, value: String)
}

extension Dependency.ViewModels {
    var addUserRewardViewModel: AddUserRewardViewModel {
        AddUserRewardViewModel(
            rewardService: services.rewardService
        )
    }
}
