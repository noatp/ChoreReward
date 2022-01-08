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
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""
    
    private var userService: UserService
    private var useCaseSubscription: AnyCancellable?
    
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
            email: emailInput,
            password: passwordInput
        )
    }
    
    func silentSignIn(){
        userService.signInIfCurrentUserExist()
    }
}

extension Dependency.ViewModels{
    var loginViewModel: LoginViewModel{
        return LoginViewModel(userService: services.userService)
    }
}
