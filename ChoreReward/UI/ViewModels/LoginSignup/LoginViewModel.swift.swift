//
//  LoginViewModel.swift.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine

class LoginViewModel: StatefulViewModel {
    @Published var _state: LoginViewState?
    var viewState: AnyPublisher<LoginViewState?, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private var userService: UserService
    private var useCaseSubscription: AnyCancellable?

    init(userService: UserService) {
        self.userService = userService
        addSubscription()
    }

    private func addSubscription() {
        useCaseSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState {
                case .signedIn:
                    break
                case .signedOut(let error):
                    guard let error = error else {
                        return
                    }
                    self?._state = .init(
                        errorMessage: error.localizedDescription,
                        shouldShowAlert: true
                    )
                case .none:
                    break
                }
            })
    }

    private func signIn(emailInput: String, passwordInput: String) {
        Task {
            await userService.signIn(email: emailInput, password: passwordInput)
        }
    }

    private func updateShouldShowAlertState(newState: Bool) {
        self._state = .init(errorMessage: "", shouldShowAlert: newState)
    }

    func performAction(_ action: LoginViewAction) {
        switch action {
        case .signIn(let emailInput, let passwordInput):
            signIn(emailInput: emailInput, passwordInput: passwordInput)
        case .updateShouldShowAlertState(let newState):
            updateShouldShowAlertState(newState: newState)
        }
    }
}

struct LoginViewState {
    let errorMessage: String
    let shouldShowAlert: Bool

    static let preview: LoginViewState = .init(errorMessage: "preview error", shouldShowAlert: true)
}

enum LoginViewAction {
    case signIn(emailInput: String, passwordInput: String)
    case updateShouldShowAlertState(newState: Bool)
}

extension Dependency.ViewModels {
    var loginViewModel: LoginViewModel {
        return LoginViewModel(userService: services.userService)
    }
}
