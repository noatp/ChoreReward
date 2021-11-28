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
    private var authSubscription: AnyCancellable?
    
    var emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    var passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password")
    
    init(authService: AuthService) {
        self.authService = authService
        addSubscription() 
    }
    
    func addSubscription(){
        authSubscription = authService.$authState
            .sink(receiveValue: { authState in
                switch authState{
                case .signedIn(_): self.errorMessage = nil
                case .signedOut(let error) : self.errorMessage = error?.localizedDescription
                }
            })
    }
    
    func signIn(){
        authService.signIn(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
    
    func signUp(){
        authService.signUp(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
}

extension Dependency{
    var loginViewModel: LoginViewModel{
        return LoginViewModel(authService: authService)
    }
}
