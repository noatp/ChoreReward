//
//  SignupViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine
import SwiftUI

class SignUpViewModel: StatefulViewModel {
    @Published var _state: SignUpState?
    var viewState: AnyPublisher<SignUpState?, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private var authStateSubscription: AnyCancellable?

    init(
        userService: UserService
    ) {
        self.userService = userService
        addSubscription()
    }

    private func addSubscription() {
        authStateSubscription = userService.$authState
            .sink(receiveValue: {[weak self] receivedAuthState in
                switch receivedAuthState {
                case .signedIn:
                    break
                case .signedOut(let error):
                    if let error = error {
                        self?._state = .init(
                            errorMessage: error.localizedDescription,
                            shouldShowAlert: true
                        )
                    } else {
                        self?._state = .init(
                            errorMessage: "",
                            shouldShowAlert: false
                        )
                    }
                case .none:
                    break
                }
            })
    }

    private func signUp(
        emailInput: String,
        nameInput: String,
        passwordInput: String,
        roleSelection: Role,
        userImageUrl: String?
    ) {
        let newUser = User(
            email: emailInput,
            name: nameInput,
            role: roleSelection
        )
        Task {
            await userService.signUp(newUser: newUser, password: passwordInput, userImageUrl: userImageUrl)
        }
    }

    private func updateShouldShowAlertState(newState: Bool) {
        self._state = .init(errorMessage: "", shouldShowAlert: newState)
    }

    func performAction(_ action: SignUpAction) {
        switch action {
        case .signUp(let emailInput, let nameInput, let passwordInput, let roleSelection, let userImageUrl):
            signUp(
                emailInput: emailInput,
                nameInput: nameInput,
                passwordInput: passwordInput,
                roleSelection: roleSelection,
                userImageUrl: userImageUrl
            )
        case .updateShouldShowAlertState(let newState):
            updateShouldShowAlertState(newState: newState)
        }
    }
}

struct SignUpState {
    let errorMessage: String
    let shouldShowAlert: Bool
    static let previewWithError: SignUpState = .init(errorMessage: "preview error", shouldShowAlert: true)
    static let previewWithoutError: SignUpState = .init(errorMessage: "", shouldShowAlert: false)
}

enum SignUpAction {
    case signUp(
        emailInput: String,
        nameInput: String,
        passwordInput: String,
        roleSelection: Role,
        userImageUrl: String?
    )
    case updateShouldShowAlertState(newState: Bool)
}

extension Dependency.ViewModels {
    var signUpViewModel: SignUpViewModel {
        SignUpViewModel(
            userService: services.userService
        )
    }
}
