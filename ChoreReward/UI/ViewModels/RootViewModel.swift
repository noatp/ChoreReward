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
    var viewState: AnyPublisher<RootViewState, Never> {
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
                guard let strongSelf = self else {
                    return
                }

                print("Here \(authState)")

                switch authState {
                case .signedIn:
                    strongSelf._state = .init(
                        shouldRenderLoginView: false
                    )
                case .signedOut:
                    strongSelf._state = .init(
                        shouldRenderLoginView: true
                    )
                case .none:
                    strongSelf.userService.silentSignIn()
                }
            })
    }

    func performAction(_ action: Void) {}
}

struct RootViewState {
    let shouldRenderLoginView: Bool

    static let empty: RootViewState = .init(shouldRenderLoginView: true)
}

extension Dependency.ViewModels {
    var rootViewModel: RootViewModel {
        RootViewModel(userService: services.userService, choreService: services.choreService)
    }
}
