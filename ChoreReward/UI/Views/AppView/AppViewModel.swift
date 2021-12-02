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
    
    init(authService: AuthService){
        self.authService = authService
    }
    
    func signOut(){
        authService.signOut()
    }
}

extension Dependency.ViewModels{
    var appViewModel: AppViewModel{
        AppViewModel(authService: services.authService)
    }
    
    
}
