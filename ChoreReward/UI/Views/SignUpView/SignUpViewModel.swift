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

    private var authService: AuthService
    private var userRepository: UserRepository
    private var authServiceSubscription: AnyCancellable?
    private var userRepoSubscription: AnyCancellable?
    
    
    let nameInputRender = TextFieldViewModel(title: "Full name", prompt: "Full name")
    let emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    let passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    let rolePickerRender = RolePickerViewModel()
    
    init(
        authService: AuthService,
        userRepository: UserRepository
    ){
        self.authService = authService
        self.userRepository = userRepository
        addSubscription()
    }
    
    func addSubscription(){
        authServiceSubscription = authService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn:
                    break
                case .signedOut(let error):
                    self?.errorMessage = error?.localizedDescription ?? nil
                }
            })
        userRepoSubscription = userRepository.$user
            .sink(receiveValue: {[weak self] userDoc in
                self?.authService.signInIfCurrentUserExist()
                self?.userRepoSubscription?.cancel()
            })
    }
    
    func signUp(){
        let newUser = User(
            id: "",
            email: emailInputRender.textInput,
            name: nameInputRender.textInput,
            role: rolePickerRender.selection
        )
        authService.signUp(
            newUser: newUser,
            password: passwordInputRender.textInput
        )
    }
    
    func getUserProfile(uid: String){
        userRepository.readUser(userId: uid)
    }
    
    
}

extension Dependency.ViewModels{
    var signUpViewModel: SignUpViewModel{
        SignUpViewModel(
            authService: services.authService,
            userRepository: repositories.userRepository
        )
    }
}
