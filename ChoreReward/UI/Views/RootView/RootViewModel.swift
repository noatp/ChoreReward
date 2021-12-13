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
    
    private var userService: UserService
    private var useCaseSubscription: AnyCancellable?
    
    
    init(userService: UserService) {
        self.userService = userService
        addSubscription()
    }
    
    func addSubscription(){
        useCaseSubscription = userService.$authState
            .sink(receiveValue: {[weak self] authState in
                switch authState{
                case .signedIn:
                    self?.shouldRenderLoginView = false
                case .signedOut(_):
                    self?.shouldRenderLoginView = true
                }
            })
    }
}

extension Dependency.ViewModels{
    var rootViewModel: RootViewModel{
        RootViewModel(userService: services.userService)
    }
}
