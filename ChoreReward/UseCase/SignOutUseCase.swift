//
//  LogoutUseCase.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/30/21.
//

import Foundation
import Combine

class SignOutUseCase{
    private var authService: AuthService
    
    init(
        authService: AuthService
    ){
        self.authService = authService
    }
    
    func signOut(){
        authService.signOut()
    }
}

extension Dependency.UseCases{
    var signOutUseCase: SignOutUseCase{
        return SignOutUseCase(
            authService: services.authService
        )
    }
}
