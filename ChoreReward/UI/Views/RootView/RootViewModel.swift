//
//  RootViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine

class RootViewModel: ObservableObject{
    @Published var shouldRenderLoginView: Bool = true
    
    private var authService: AuthService
    private var useCaseSubscription: AnyCancellable?
    
    
    init(authService: AuthService) {
        self.authService = authService
        addSubscription()
    }
    
    func addSubscription(){
        useCaseSubscription = authService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn(_, let newUser):
                    if (!newUser){
                        self?.shouldRenderLoginView = false
                    }
                case .signedOut(_):
                    self?.shouldRenderLoginView = true
                }
            })
    }
}

extension Dependency.ViewModels{
    var rootViewModel: RootViewModel{
        RootViewModel(authService: services.authService)
    }
}
