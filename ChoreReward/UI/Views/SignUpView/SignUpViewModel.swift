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
                case .signedIn(let currentUser, let newUser):
                    if (newUser){
                        self?.userRepository.createUser(
                            userId: currentUser.uid,
                            name: self?.nameInputRender.textInput ?? nil,
                            email: self?.emailInputRender.textInput ?? nil
                        )
                    }
                    break
                case .signedOut(let error):
                    self?.errorMessage = error?.localizedDescription ?? nil
                }
            })
        userRepoSubscription = userRepository.$user
            .sink(receiveValue: {[weak self] userDoc in
                self?.authService.silentAuth()
                self?.userRepoSubscription?.cancel()
            })
    }
    
    func signUp(){
        authService.signUp(
            email: emailInputRender.textInput,
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
