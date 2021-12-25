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

    private var userService: UserService
    private var authStateSubscription: AnyCancellable?
    
    let nameInputRender = TextFieldViewModel(title: "Full name", prompt: "Full name")
    let emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    let passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    let rolePickerRender = RolePickerViewModel()
    
    init(
        userService: UserService
    ){
        self.userService = userService
        addSubscription()
    }
    
    func addSubscription(){
        authStateSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn:
                    break
                case .signedOut(let error):
                    self?.errorMessage = error?.localizedDescription ?? nil
                }
            })
    }
    
    func signUp(){
        let newUser = User(
            id: "",
            email: emailInputRender.textInput,
            name: nameInputRender.textInput,
            role: rolePickerRender.selection
        )
        userService.signUp(
            newUser: newUser,
            password: passwordInputRender.textInput
        )
    }
}

extension Dependency.ViewModels{
    var signUpViewModel: SignUpViewModel{
        SignUpViewModel(
            userService: services.userService
        )
    }
}
