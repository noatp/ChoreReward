//
//  ChoreDetailViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import Foundation
import Combine

class ChoreDetailViewModel: StatefulViewModel {
    @Published var _state: ChoreDetailState?
    var viewState: AnyPublisher<ChoreDetailState?, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let choreSerivce: ChoreService
    private let userService: UserService

    init(
        chore: Chore,
        choreService: ChoreService,
        userService: UserService
    ) {
        self.choreSerivce = choreService
        self.userService = userService
        self._state = .init(chore: chore)
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
            choreId: self._state?.chore.id,
            currentUser: userService.currentUser
        )
    }

    private func completeChore() {
        choreSerivce.completeChore(choreId: self._state?.chore.id)
    }
}

struct ChoreDetailState {
    let chore: Chore
    static let preview: ChoreDetailState = .init(chore: .previewChoreFinished)
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
