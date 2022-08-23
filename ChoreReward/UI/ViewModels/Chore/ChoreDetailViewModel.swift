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
    private let choreId: String
    private var choreDetailSubscription: AnyCancellable?

    init(
        choreId: String,
        choreService: ChoreService,
        userService: UserService
    ) {
        self.choreId = choreId
        self.choreSerivce = choreService
        self.userService = userService
        addSubscription()
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

    private func addSubscription() {
        choreDetailSubscription = choreSerivce.$familyChores
            .sink(receiveValue: { [weak self] receivedFamilyChores in
                guard let receivedFamilyChores = receivedFamilyChores else {
                    return
                }

                let choreDetail = receivedFamilyChores.first { chore in
                    chore.id == self?.choreId
                }

                if let choreDetail = choreDetail {
                    self?._state = .init(chore: choreDetail)
                }
            })
    }
}

struct ChoreDetailState {
    let chore: Chore
    static let previewFinished: ChoreDetailState = .init(chore: .previewChoreFinished)
    static let previewUnfinished: ChoreDetailState = .init(chore: .previewChoreUnfinished)
    static let previewUnassigned: ChoreDetailState = .init(chore: .previewUnassignedChore)
}

enum ChoreDetailAction {
    // case someAction(parameter: ParameterType)
    case takeChore
    case completeChore
}

extension Dependency.ViewModels {
    func choreDetailViewModel(choreId: String) -> ChoreDetailViewModel {
        ChoreDetailViewModel(
            choreId: choreId,
            choreService: services.choreService,
            userService: services.userService
        )
    }
}
