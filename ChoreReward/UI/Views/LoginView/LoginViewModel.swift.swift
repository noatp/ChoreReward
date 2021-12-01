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
    
    private var loginUseCase: LoginUseCase
    private var useCaseSubscription: AnyCancellable?
    
    var emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    var passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        addSubscription()
        self.loginUseCase.silentLogin()
    }
    
    func addSubscription(){
        useCaseSubscription = loginUseCase.$result
            .sink(receiveValue: { useCaseResult in
                switch useCaseResult{
                case .success(let returnData):
                    break
                case .error(let error):
                    break
                }
            })
    }
    
    func signIn(){
        loginUseCase.login(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
}

extension Dependency.ViewModels{
    var loginViewModel: LoginViewModel{
        return LoginViewModel(loginUseCase: useCases.loginUseCase)
    }
}
