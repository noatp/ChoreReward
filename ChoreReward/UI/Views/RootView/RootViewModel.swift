//
//  RootViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine

class RootViewModel: StatefulViewModel {
    @Published var _state = empty
    static let empty: RootViewState = .empty
    var state: AnyPublisher<RootViewState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private var userService: UserService
    private var choreService: ChoreService

    private var authStateSubscription: AnyCancellable?
    private var userServiceBusyStatusSubscription: AnyCancellable?
    private var choreServiceBusyStatusSubscription: AnyCancellable?

    init(userService: UserService, choreService: ChoreService) {
        self.userService = userService
        self.choreService = choreService
        addSubscription()
    }

    func addSubscription() {
        authStateSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                guard let oldState = self?._state else {
                    return
                }
                switch authState {
                case .signedIn:
                    self?._state = .init(
                        shouldRenderLoginView: false,
                        shouldRenderProgressView: oldState.shouldRenderProgressView
                    )
                case .signedOut:
                    self?._state = .init(
                        shouldRenderLoginView: true,
                        shouldRenderProgressView: oldState.shouldRenderProgressView
                    )
                }
            })
        choreServiceBusyStatusSubscription = choreService.$isBusy
            .sink(receiveValue: { [weak self] busyStatus in
                guard let oldState = self?._state else {
                    return
                }

                self?._state = .init(
                    shouldRenderLoginView: oldState.shouldRenderLoginView,
                    shouldRenderProgressView: busyStatus
                )
            })
    }

    func performAction(_ action: Void) {}
}

struct RootViewState {
    let shouldRenderLoginView: Bool
    let shouldRenderProgressView: Bool

    static let empty: RootViewState = .init(shouldRenderLoginView: true, shouldRenderProgressView: false)
}

extension Dependency.ViewModels {
    var rootViewModel: RootViewModel {
        RootViewModel(userService: services.userService, choreService: services.choreService)
    }
}
