//
//  LoginUseCase.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/30/21.
//

import Foundation
import Combine

class SignInUseCase{
    @Published var result: UseCaseResult<String>
    
    private var authService: AuthService
    private var userRepository: UserRepository
    private var authSubscription: AnyCancellable?
    
    init(
        authService: AuthService,
        userRepository: UserRepository
    ){
        self.authService = authService
        self.userRepository = userRepository
        self.result = UseCaseResult.success(returnData: nil)
        addSubscription()
    }
    
    func addSubscription(){
        authSubscription = authService.$authState
            .sink(receiveValue: { authState in
                switch authState{
                case .signedIn(let currentUser, let newUser):
                    //successfully signed in
                    if (!newUser){
                        self.readUser(uid: currentUser.uid)
                    }
                    self.result = UseCaseResult.success(returnData: currentUser.uid)
                case .signedOut(let error):
                    if (error != nil){
                        //having error in signing in or signing out
                        self.result = UseCaseResult.error(error: error!)
                    }
                    else {
                        //successfully signed out
                        self.result = UseCaseResult.success(returnData: nil)
                    }
                }
            })
    }
    
    func login(email: String, password: String){
        authService.signIn(email: email, password: password)
    }
    
    func readUser(uid: String){
        print("read user")
        userRepository.readUser(userId: uid)
    }
    
    func silentLogin(){
        authService.silentAuth()
    }
}

extension Dependency.UseCases{
    var signInUseCase: SignInUseCase{
        return SignInUseCase(
            authService: services.authService,
            userRepository: repositories.userRepository
        )
    }
}
