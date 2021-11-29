//
//  SignupViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine

class SignupViewModel: ObservableObject{
    @Published var errorMessage: String? = nil

    private var authService: AuthService
    private var authSubscription: AnyCancellable?
    
    let nameInputRender = TextFieldViewModel(title: "Full name", prompt: "Full name")
    let emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    let passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    
    init(authService: AuthService){
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
    
    func signUp(){
        authService.signUp(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
    
}

extension Dependency{
    var signupViewModel: SignupViewModel{
        SignupViewModel(authService: authService)
    }
}
