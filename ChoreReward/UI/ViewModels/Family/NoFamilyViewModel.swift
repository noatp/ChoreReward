//
//  NoFamilyViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/26/21.
//

import Foundation
import Combine

class NoFamilyViewModel: StatefulViewModel {
    @Published var _state: NoFamilyState?
    var viewState: AnyPublisher<NoFamilyState?, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private let familyService: FamilyService
    private var currentUserSubscription: AnyCancellable?

    init(
        userService: UserService,
        familyService: FamilyService
    ) {
        self.userService = userService
        self.familyService = familyService
        addSubscription()
    }

    func addSubscription() {
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                guard let receivedUser = receivedUser, let receivedUserId = receivedUser.id else {
                    return
                }
                self?._state = .init(
                    shouldRenderCreateFamilyButton: receivedUser.role == .parent,
                    currentUserId: receivedUserId
                )
            })
    }

    func createFamily() {
        guard let currentUserId = userService.currentUserId else {
            return
        }
        Task {
            await familyService.createFamily(currentUserId: currentUserId)
        }
    }

    func performAction(_ action: NoFamilyAction) {
        switch action {
        case .createFamily:
            createFamily()
        }
    }
}

struct NoFamilyState {
    let shouldRenderCreateFamilyButton: Bool
    let currentUserId: String
    static let preview: NoFamilyState = .init(shouldRenderCreateFamilyButton: true, currentUserId: "previewId")
}

enum NoFamilyAction {
    case createFamily
}

extension Dependency.ViewModels {
    var noFamilyViewModel: NoFamilyViewModel {
        NoFamilyViewModel(
            userService: services.userService,
            familyService: services.familyService
        )
    }
}
