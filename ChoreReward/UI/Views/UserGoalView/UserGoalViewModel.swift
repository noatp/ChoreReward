//
//  UserGoalViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import Foundation
import Combine

class UserGoalViewModel: StatefulViewModel {
    @Published var _state: UserGoalState = empty
    static let empty = UserGoalState.empty
    var state: AnyPublisher<UserGoalState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    // private var subscription: AnyCancellable?

    init(
        userService: UserService
    ) {
        self.userService = userService
        self.addSubscription()
    }

    func addSubscription() {

    }

//    private func something(){
//
//    }

    func performAction(_ action: UserGoalAction) {
        switch action {
//        case .action(let name):
//            //call a private func
        }
    }
}

struct UserGoalState {
    let currentGoalName: String?
    let currentGoalValue: Float?

    static let empty: UserGoalState = .init(
        currentGoalName: "",
        currentGoalValue: 0.00
    )
}

enum UserGoalAction {
    // case action(name: type)
}

extension Dependency.ViewModels {
    var userGoalViewModel: UserGoalViewModel {
        UserGoalViewModel(userService: services.userService)
    }
}
