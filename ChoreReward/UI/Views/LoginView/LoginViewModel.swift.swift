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

class LoginViewModel: StatefulViewModel{
    @Published var _state: LoginViewState = empty
    static let empty = LoginViewState(errorMessage: "")
    var state: AnyPublisher<LoginViewState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    private var userService: UserService
    private var useCaseSubscription: AnyCancellable?
    
    init(userService: UserService) {
        self.userService = userService
        addSubscription()
    }
    
    func addSubscription(){
        useCaseSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn:
                    break
                case .signedOut(let error):
                    self?._state = .init(errorMessage: error?.localizedDescription ?? "")
                }
            })
    }
    
    func signIn(emailInput: String, passwordInput: String){
        Task{
            await userService.signIn(email: emailInput, password: passwordInput)
        }
    }
    
    func silentSignIn(){
        Task{
            await userService.silentSignIn()
        }
    }
    
    func performAction(_ action: LoginViewAction) {
        switch action{
        case .signIn(let emailInput, let passwordInput):
            signIn(emailInput: emailInput, passwordInput: passwordInput)
        case .silentSignIn:
            silentSignIn()
        }

    }
}

struct LoginViewState{
    let errorMessage: String
}

enum LoginViewAction{
    case signIn(emailInput: String, passwordInput: String)
    case silentSignIn
}

extension Dependency.ViewModels{
    var loginViewModel: LoginViewModel{
        return LoginViewModel(userService: services.userService)
    }
}
