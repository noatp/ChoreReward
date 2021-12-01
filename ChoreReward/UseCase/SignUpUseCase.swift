//
//  SignupUseCase.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/30/21.
//

import Foundation
import Combine

class SignUpUseCase{
    @Published var result: UseCaseResult<User>
    
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
                case .signedIn(let currentUser):
                    self.createUser(uid: currentUser.uid)
                case .signedOut(let error):
                    if let error = error{
                        self.result = UseCaseResult.error(error: error)
                    }
                }
            })
    }
    
    func signUp(email: String, password: String){
        authService.signUp(email: email, password: password)
    }
    
    func createUser(uid: String){
        
    }
}

extension Dependency.UseCases{
    var signUpUseCase: SignUpUseCase{
        return SignUpUseCase(
            authService: services.authService,
            userRepository: repositories.userRepository
        )
    }
}
