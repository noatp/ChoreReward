//
//  AppViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/27/21.
//

import Foundation
import Combine

class AppViewModel: StatefulViewModel {
    @Published var _state: AppViewState?
    var viewState: AnyPublisher<AppViewState?, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private let notificationService: NotificationService
    private let choreService: ChoreService
    private var currentUserSubscription: AnyCancellable?
    private var choreIdFromNotificationSubscription: AnyCancellable?

    init(
        userService: UserService,
        notificationService: NotificationService,
        choreService: ChoreService
    ) {
        self.userService = userService
        self.notificationService = notificationService
        self.choreService = choreService
        addSubscription()
    }

    func addSubscription() {
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                guard let receivedUser = receivedUser else {
                    return
                }
                if let oldState = self?._state {
                    self?._state = .init(
                        shouldRenderAddChoreButton: receivedUser.role == .parent || receivedUser.role == .admin,
                        shouldPresentNoFamilyView: receivedUser.familyId == nil,
                        shouldNavigateToNotificationChore: oldState.shouldNavigateToNotificationChore,
                        notificationChore: oldState.notificationChore
                    )
                } else {
                    self?._state = .init(
                        shouldRenderAddChoreButton: receivedUser.role == .parent || receivedUser.role == .admin,
                        shouldPresentNoFamilyView: receivedUser.familyId == nil,
                        shouldNavigateToNotificationChore: false,
                        notificationChore: Chore.empty
                    )
                }
            })

        choreIdFromNotificationSubscription = notificationService.$choreIdFromNotification
            .sink(receiveValue: { [weak self] receivedChoreId in
                guard let receivedChoreId = receivedChoreId else {
                    return
                }
                self?.choreService.getChore(withId: receivedChoreId) { receivedChore in
                    guard let receivedChore = receivedChore else {
                        return
                    }
                    if let oldState = self?._state {
                        self?._state = .init(
                            shouldRenderAddChoreButton: oldState.shouldRenderAddChoreButton,
                            shouldPresentNoFamilyView: oldState.shouldPresentNoFamilyView,
                            shouldNavigateToNotificationChore: true,
                            notificationChore: receivedChore
                        )
                    } else {
                        self?._state = .init(
                            shouldRenderAddChoreButton: false,
                            shouldPresentNoFamilyView: false,
                            shouldNavigateToNotificationChore: true,
                            notificationChore: receivedChore
                        )
                    }
                }
            })
    }

    private func updateShouldShouldNavigateToNotificationState(newState: Bool) {
        guard let oldState = self._state else {
            return
        }
        self._state = .init(
            shouldRenderAddChoreButton: oldState.shouldRenderAddChoreButton,
            shouldPresentNoFamilyView: oldState.shouldPresentNoFamilyView,
            shouldNavigateToNotificationChore: newState,
            notificationChore: oldState.notificationChore
        )
    }

    func performAction(_ action: AppViewAction) {
        switch action {
        case .updateShouldShouldNavigateToNotificationState(let newState):
            updateShouldShouldNavigateToNotificationState(newState: newState)
        }
    }

}

struct AppViewState {
    let shouldRenderAddChoreButton: Bool
    let shouldPresentNoFamilyView: Bool
    let shouldNavigateToNotificationChore: Bool
    let notificationChore: Chore
    static let preview: AppViewState = .init(
        shouldRenderAddChoreButton: true,
        shouldPresentNoFamilyView: false,
        shouldNavigateToNotificationChore: false,
        notificationChore: Chore.empty
    )
}

enum AppViewAction {
    case updateShouldShouldNavigateToNotificationState(newState: Bool)
}

extension Dependency.ViewModels {
    var appViewModel: AppViewModel {
        AppViewModel(
            userService: services.userService,
            notificationService: services.notificationService,
            choreService: services.choreService
        )
    }
}
