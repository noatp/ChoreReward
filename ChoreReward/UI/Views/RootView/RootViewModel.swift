//
//  RootViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine

class RootViewModel: ObservableObject{
    @Published var shouldRenderLoginView: Bool = false
    
    private var authService: AuthService    
    private var authSubscription: AnyCancellable?
    
    
    init(authService: AuthService) {
        self.authService = authService
        addSubscription()
    }
    
    func addSubscription(){
        authSubscription = authService.$authState
            .sink(receiveValue: { authState in
                switch authState{
                case .signedIn(_):
                    self.shouldRenderLoginView = false
                case.signedOut(_):
                    self.shouldRenderLoginView = true
                }
            })
    }
}

extension Dependency{
    var rootViewModel: RootViewModel{
        RootViewModel(authService: authService)
    }
}
