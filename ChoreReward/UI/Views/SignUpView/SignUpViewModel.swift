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
    static let empty = SignUpState(errorMessage: "")
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

    func addSubscription() {
        authStateSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState {
                case .signedIn:
                    break
                case .signedOut(let error):
                    self?._state = .init(errorMessage: error?.localizedDescription ?? "")
                }

            })
    }

    func signUp(
        emailInput: String,
        nameInput: String,
        passwordInput: String,
        roleSelection: Role,
        profileImage: UIImage?
    ) {
        let newUser = User(
            email: emailInput,
            name: nameInput,
            role: roleSelection,
            profileImageUrl: ""
        )
        Task {
            await userService.signUp(newUser: newUser, password: passwordInput, profileImage: profileImage)
        }
    }

    func performAction(_ action: SignUpAction) {
        switch action {
        case .signUp(let emailInput, let nameInput, let passwordInput, let roleSelection, let profileImage):
            signUp(
                emailInput: emailInput,
                nameInput: nameInput,
                passwordInput: passwordInput,
                roleSelection: roleSelection,
                profileImage: profileImage
            )
        }
    }
}

struct SignUpState {
    let errorMessage: String
}

enum SignUpAction {
    case signUp(
        emailInput: String,
        nameInput: String,
        passwordInput: String,
        roleSelection: Role,
        profileImage: UIImage?
    )
}

extension Dependency.ViewModels {
    var signUpViewModel: SignUpViewModel {
        SignUpViewModel(
            userService: services.userService
        )
    }
}
