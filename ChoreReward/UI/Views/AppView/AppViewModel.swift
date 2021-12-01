//
//  AppViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/27/21.
//

import Foundation
import Combine

class AppViewModel: ObservableObject{
    private var signOutUseCase: SignOutUseCase
    
    init(signOutUseCase: SignOutUseCase){
        self.signOutUseCase = signOutUseCase
    }
    
    func signOut(){
        signOutUseCase.signOut()
    }
}

extension Dependency.ViewModels{
    var appViewModel: AppViewModel{
        AppViewModel(signOutUseCase: useCases.signOutUseCase)
    }
    
    
}
