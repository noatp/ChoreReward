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
    
    private var userService: UserService
    private var useCaseSubscription: AnyCancellable?
    
    var emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    var passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    
    init(userService: UserService) {
        self.userService = userService
        addSubscription()
        self.silentSignIn()
    }
    
    func addSubscription(){
        useCaseSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn:
                    break
                case .signedOut(let error):
                    self?.errorMessage = error?.localizedDescription
                }
            })
    }
    
    func signIn(){
        userService.signIn(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
    
    func silentSignIn(){
        print("silentSignIn called here")
        userService.signInIfCurrentUserExist()
    }
}

extension Dependency.ViewModels{
    var loginViewModel: LoginViewModel{
        return LoginViewModel(userService: services.userService)
    }
}
