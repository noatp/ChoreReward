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
    @Published var isSignedIn: Bool = false
    
    var emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    var passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password")
    
    private var authenticationService: AuthService
    private var authSubscription: AnyCancellable?
    
    init(authenticationService: AuthService) {
        self.authenticationService = authenticationService
        addSubscription() 
    }
    
    func addSubscription(){
        authSubscription = authenticationService.$authState
            .sink(receiveValue: { [weak self] authState in
                switch authState{
                case .signedIn(_): self?.isSignedIn = true
                case .signedOut(_) : self?.isSignedIn = false
                }
            })
    }
    
    func signIn(){
        authenticationService.signIn(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
    
    func signUp(){
        authenticationService.signUp(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
    
    func signOut(){
        authenticationService.signOut()
    }
}

extension Dependency{
    var loginViewModel: LoginViewModel{
        return LoginViewModel(authenticationService: authenticationService)
    }
}
