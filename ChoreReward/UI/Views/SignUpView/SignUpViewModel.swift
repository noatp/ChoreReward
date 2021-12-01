//
//  SignupViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject{
    @Published var errorMessage: String? = nil

    private var signupUseCase: SignUpUseCase
    private var useCaseSubscription: AnyCancellable?
    
    
    let nameInputRender = TextFieldViewModel(title: "Full name", prompt: "Full name")
    let emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    let passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    
    init(signUpUseCase: SignUpUseCase){
        self.signupUseCase = signUpUseCase
        addSubscription()
    }
    
    func addSubscription(){
        useCaseSubscription = signupUseCase.$result
            .sink(receiveValue: { useCaseResult in
                switch useCaseResult{
                case .success(_):
                    break
                case .error(_):
                    break
                }
            })
    }
    
    func signUp(){
        signupUseCase.signUp(
            email: emailInputRender.textInput,
            password: passwordInputRender.textInput
        )
    }
    
}

extension Dependency.ViewModels{
    var signUpViewModel: SignUpViewModel{
        SignUpViewModel(signUpUseCase: useCases.signUpUseCase)
    }
}
