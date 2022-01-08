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
    @Published var nameInput: String = ""
    @Published var emailInput: String = ""
    @Published var passwordInput: String = ""

    private var userService: UserService
    private var authStateSubscription: AnyCancellable?
    
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
            email: emailInput,
            name: nameInput,
            role: rolePickerRender.selection
        )
        userService.signUp(
            newUser: newUser,
            password: passwordInput
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
