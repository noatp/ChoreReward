//
//  AppViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/27/21.
//

import Foundation
import Combine

class AppViewModel: StatefulViewModel {
    @Published var _state = empty
    static var empty: AppViewState = .empty
    var viewState: AnyPublisher<AppViewState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private var currentUserSubscription: AnyCancellable?

    init(userService: UserService) {
        self.userService = userService
        addSubscription()
    }

    func addSubscription() {
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: {[weak self] receivedUser in
                print("\(#fileID) \(#function): \(receivedUser)")

                self?._state = .init(
                    shouldRenderAddChoreButton: receivedUser?.role == .parent || receivedUser?.role == .admin,
                    shouldPresentNoFamilyView: receivedUser?.familyId == nil
                )
            })
    }

    func performAction(_ action: Void) {}

}

struct AppViewState {
    let shouldRenderAddChoreButton: Bool
    let shouldPresentNoFamilyView: Bool

    static let empty: AppViewState = .init(
        shouldRenderAddChoreButton: true,
        shouldPresentNoFamilyView: false
    )
}

extension Dependency.ViewModels {
    var appViewModel: AppViewModel {
        AppViewModel(userService: services.userService)
    }
}
