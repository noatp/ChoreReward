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
    @Published var _state: SignUpState = empty
    static let empty: SignUpState = .empty
    var state: AnyPublisher<SignUpState, Never> {
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
                        shouldAlert: true
                    )
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

    private func updateShouldAlertState(newState: Bool) {
        self._state = .init(errorMessage: "", shouldAlert: newState)
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
        case .updateShouldAlertState(let newState):
            updateShouldAlertState(newState: newState)
        }
    }
}

struct SignUpState {
    let errorMessage: String
    let shouldAlert: Bool

    static let empty: SignUpState = .init(errorMessage: "", shouldAlert: false)
    static let preview: SignUpState = .init(errorMessage: "preview error", shouldAlert: true)
}

enum SignUpAction {
    case signUp(
        emailInput: String,
        nameInput: String,
        passwordInput: String,
        roleSelection: Role,
        userImageUrl: String?
    )
    case updateShouldAlertState(newState: Bool)
}

extension Dependency.ViewModels {
    var signUpViewModel: SignUpViewModel {
        SignUpViewModel(
            userService: services.userService
        )
    }
}
