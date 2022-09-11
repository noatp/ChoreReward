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
    private let deepLinkService: DeepLinkService
    private var currentUserSubscription: AnyCancellable?
    private var choreIdFromNotificationSubscription: AnyCancellable?

    init(
        userService: UserService,
        notificationService: NotificationService,
        choreService: ChoreService,
        deepLinkService: DeepLinkService = .init()
    ) {
        self.userService = userService
        self.notificationService = notificationService
        self.choreService = choreService
        self.deepLinkService = deepLinkService
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
                        shouldNavigateToDeepLink: oldState.shouldNavigateToDeepLink,
                        shouldShowAddMemberOnFirstLaunch: receivedUser.role == .admin,
                        deepLinkTarget: oldState.deepLinkTarget
                    )
                } else {
                    self?._state = .init(
                        shouldRenderAddChoreButton: receivedUser.role == .parent || receivedUser.role == .admin,
                        shouldPresentNoFamilyView: receivedUser.familyId == nil,
                        shouldNavigateToDeepLink: false,
                        shouldShowAddMemberOnFirstLaunch: receivedUser.role == .admin,
                        deepLinkTarget: .none
                    )
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
            shouldNavigateToDeepLink: newState,
            shouldShowAddMemberOnFirstLaunch: oldState.shouldShowAddMemberOnFirstLaunch,
            deepLinkTarget: .none
        )
    }

    private func parseUrlToDeepLinkTarget(_ url: URL) {
        guard let oldState = self._state else {
            return
        }
        let deepLinkTarget = deepLinkService.parseUrlToDeepLinkTarget(url)
        print("\(#fileID) \(#function) \(deepLinkTarget)")
        self._state = .init(
            shouldRenderAddChoreButton: oldState.shouldRenderAddChoreButton,
            shouldPresentNoFamilyView: oldState.shouldPresentNoFamilyView,
            shouldNavigateToDeepLink: true,
            shouldShowAddMemberOnFirstLaunch: oldState.shouldShowAddMemberOnFirstLaunch,
            deepLinkTarget: deepLinkTarget
        )
    }

    func performAction(_ action: AppViewAction) {
        switch action {
        case .updateShouldShouldNavigateToNotificationState(let newState):
            updateShouldShouldNavigateToNotificationState(newState: newState)
        case .parseUrlToDeepLinkTarget(let url):
            parseUrlToDeepLinkTarget(url)
        }

    }

}

struct AppViewState {
    let shouldRenderAddChoreButton: Bool
    let shouldPresentNoFamilyView: Bool
    let shouldNavigateToDeepLink: Bool
    let shouldShowAddMemberOnFirstLaunch: Bool
    let deepLinkTarget: DeepLinkTarget
    static let preview: AppViewState = .init(
        shouldRenderAddChoreButton: true,
        shouldPresentNoFamilyView: false,
        shouldNavigateToDeepLink: false,
        shouldShowAddMemberOnFirstLaunch: false,
        deepLinkTarget: .none
    )
}

enum AppViewAction {
    case updateShouldShouldNavigateToNotificationState(newState: Bool)
    case parseUrlToDeepLinkTarget(_ url: URL)
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
