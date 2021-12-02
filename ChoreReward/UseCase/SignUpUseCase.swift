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
    
    //expand later to store more data?
    private var newUserEmail: String? = nil
    private var newUserName: String? = nil
    
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
                    if (newUser){
                        self.createUser(uid: currentUser.uid)
                    }
                case .signedOut(let error):
                    if let error = error{
                        self.result = UseCaseResult.error(error: error)
                    }
                }
            })
    }
    
    func signUp(name: String, email: String, password: String){
        authService.signUp(email: email, password: password)
        newUserEmail = email
        print(email)
        newUserName = name
        print(name)
    }
    
    func createUser(uid: String){
        print("create user")
        print(newUserName)
        userRepository.createUser(userId: uid, name: newUserName!, email: newUserEmail!)
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
