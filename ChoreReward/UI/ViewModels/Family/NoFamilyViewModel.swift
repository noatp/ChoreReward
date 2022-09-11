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
                    currentUserId: receivedUserId,
                    shouldShowProgressView: false
                )
            })
    }

    private func createFamily() {
        guard let oldState = self._state else {
            return
        }
        self._state = .init(
            shouldRenderCreateFamilyButton: oldState.shouldRenderCreateFamilyButton,
            currentUserId: oldState.currentUserId,
            shouldShowProgressView: true
        )
        guard let currentUserId = userService.currentUserId else {
            return
        }
        Task {
            await familyService.createFamily(currentUserId: currentUserId)
        }
    }

    private func signOut() {
        userService.signOut()
    }

    func performAction(_ action: NoFamilyAction) {
        switch action {
        case .createFamily:
            createFamily()
        case .signOut:
            signOut()
        }
    }
}

struct NoFamilyState {
    let shouldRenderCreateFamilyButton: Bool
    let currentUserId: String
    let shouldShowProgressView: Bool
    static let preview: NoFamilyState = .init(
        shouldRenderCreateFamilyButton: true,
        currentUserId: "previewId",
        shouldShowProgressView: false
    )
    static let previewWithProgressView: NoFamilyState = .init(
        shouldRenderCreateFamilyButton: true,
        currentUserId: "previewId",
        shouldShowProgressView: true
    )
}

enum NoFamilyAction {
    case createFamily
    case signOut
}

extension Dependency.ViewModels {
    var noFamilyViewModel: NoFamilyViewModel {
        NoFamilyViewModel(
            userService: services.userService,
            familyService: services.familyService
        )
    }
}
