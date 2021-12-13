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
    private var userRepository: UserRepository
    private var userServiceSubscription: AnyCancellable?
    private var userRepoSubscription: AnyCancellable?
    
    
    let nameInputRender = TextFieldViewModel(title: "Full name", prompt: "Full name")
    let emailInputRender = TextFieldViewModel(title: "Email", prompt: "Email")
    let passwordInputRender = TextFieldViewModel(title: "Password", prompt: "Password", secure: true)
    let rolePickerRender = RolePickerViewModel()
    
    init(
        userService: UserService,
        userRepository: UserRepository
    ){
        self.userService = userService
        self.userRepository = userRepository
        addSubscription()
    }
    
    func addSubscription(){
        userServiceSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn:
                    break
                case .signedOut(let error):
                    self?.errorMessage = error?.localizedDescription ?? nil
                }
            })
        userRepoSubscription = userRepository.$currentUser
            .sink(receiveValue: {[weak self] userDoc in
                self?.userService.signInIfCurrentUserExist()
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
        userService.signUp(
            newUser: newUser,
            password: passwordInputRender.textInput
        )
    }
    
    func getUserProfile(uid: String){
        userRepository.readOtherUser(otherUserId: uid)
    }
    
    
}

extension Dependency.ViewModels{
    var signUpViewModel: SignUpViewModel{
        SignUpViewModel(
            userService: services.userService,
            userRepository: repositories.userRepository
        )
    }
}
