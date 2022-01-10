//
//  RootViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine

class RootViewModel: StatefulViewModel{
    @Published var _state: RootViewState = empty
    static let empty = RootViewState(shouldRenderLoginView: false)
    var state: AnyPublisher<RootViewState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
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
                    self?._state = .init(shouldRenderLoginView: false)
                case .signedOut(_):
                    self?._state = .init(shouldRenderLoginView: true)
                }
            })
    }
    
    func performAction(_ action: Void) {}
}

struct RootViewState{
    let shouldRenderLoginView: Bool
}

extension Dependency.ViewModels{
    var rootViewModel: RootViewModel{
        RootViewModel(userService: services.userService)
    }
}
