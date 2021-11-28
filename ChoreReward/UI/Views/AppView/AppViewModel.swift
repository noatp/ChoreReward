//
//  AppViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/27/21.
//

import Foundation
import Combine

class AppViewModel: ObservableObject{
    private var authService: AuthService
    private var authSubscription: AnyCancellable?
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signOut(){
        authService.signOut()
    }
    
    func getCurrentUserUUID() -> String{
        return authService.auth.currentUser!.uid
    }
}

extension Dependency{
    var appViewModel: AppViewModel{
        AppViewModel(authService: authService)
    }
    
    
}
