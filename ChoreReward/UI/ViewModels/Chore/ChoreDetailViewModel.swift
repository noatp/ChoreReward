//
//  ChoreDetailViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import Foundation
import Combine

class ChoreDetailViewModel: StatefulViewModel {
    @Published var _state: ChoreDetailState = empty
    static let empty: ChoreDetailState = .init(chore: Chore.empty)
    var state: AnyPublisher<ChoreDetailState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let choreSerivce: ChoreService
    private let userService: UserService
    private let chore: Chore

    init(
        chore: Chore,
        choreService: ChoreService,
        userService: UserService
    ) {
        self._state = .init(chore: chore)
        self.choreSerivce = choreService
        self.userService = userService
        self.chore = chore
    }

    func performAction(_ action: ChoreDetailAction) {
        switch action {
        case .takeChore:
            self.takeChore()
        case .completeChore:
            self.completeChore()
        }
    }

    private func takeChore() {
        choreSerivce.takeChore(
            choreId: chore.id,
            currentUserId: userService.currentUserId
        )
    }

    private func completeChore() {
        choreSerivce.completeChore(choreId: chore.id)
    }
}

struct ChoreDetailState {
    let chore: Chore
    let choreTaken: Bool
    let choreCompleted: Bool

    init(chore: Chore) {
        self.chore = chore
        self.choreTaken = chore.assigneeId != ""
        self.choreCompleted = chore.completed != nil
    }
}

enum ChoreDetailAction {
    // case someAction(parameter: ParameterType)
    case takeChore
    case completeChore
}

extension Dependency.ViewModels {
    func choreDetailViewModel(chore: Chore) -> ChoreDetailViewModel {
        ChoreDetailViewModel(
            chore: chore,
            choreService: services.choreService,
            userService: services.userService
        )
    }
}
