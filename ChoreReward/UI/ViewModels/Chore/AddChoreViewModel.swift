//
//  AddChoreViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import Foundation
import Combine
import SwiftUI

class AddChoreViewModel: StatefulViewModel {
    @Published var _state: AddChoreState = empty
    static let empty: AddChoreState = .init()
    var viewState: AnyPublisher<AddChoreState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let choreService: ChoreService
    private let userService: UserService

    init(
        choreService: ChoreService,
        userService: UserService
    ) {
        self._state = .init()
        self.choreService = choreService
        self.userService = userService
    }

    func createChore(choreTitle: String, choreDescription: String, choreImageUrl: String, choreRewardValue: String) {
        guard let currentUser = userService.currentUser,
                currentUser.role != .child
        else {
            return
        }
        choreService.createChore(
            withTitle: choreTitle,
            withDescription: choreDescription,
            withImageUrl: choreImageUrl,
            withRewardValue: choreRewardValue,
            byUser: currentUser
        )
    }

    func performAction(_ action: AddChoreAction) {
         switch action {
         case .createChore(let choreTitle, let choreDescription, let choreImageUrl, let choreRewardValue):
             createChore(
                choreTitle: choreTitle,
                choreDescription: choreDescription,
                choreImageUrl: choreImageUrl,
                choreRewardValue: choreRewardValue
             )
         }
    }
}

struct AddChoreState {
    // let something: SOMETHING
}

enum AddChoreAction {
    case createChore(choreTitle: String, choreDescription: String, choreImageUrl: String, choreRewardValue: String)
}

extension Dependency.ViewModels {
    var addChoreViewModel: AddChoreViewModel {
        AddChoreViewModel(choreService: services.choreService, userService: services.userService)
    }
}
