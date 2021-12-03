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

class LoginViewModel: ObservableObject{
    @Published var errorMessage: String? = nil
    
    private var authService: AuthService
    private var useCaseSubscription: AnyCancellable?
    
    var emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    var passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    
    init(authService: AuthService) {
        self.authService = authService
        addSubscription()
        self.silentSignIn()
    }
    
    func addSubscription(){
        useCaseSubscription = authService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn(_, _):
                    break
                case .signedOut(let error):
                    self?.errorMessage = error?.localizedDescription
                }
            })
    }
    
    func signIn(){
        authService.signIn(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
    
    func silentSignIn(){
        authService.silentAuth()
    }
}

extension Dependency.ViewModels{
    var loginViewModel: LoginViewModel{
        return LoginViewModel(authService: services.authService)
    }
}
