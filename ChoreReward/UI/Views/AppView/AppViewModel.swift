//
//  AppViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/27/21.
//

import Foundation
import Combine

class AppViewModel: StatefulViewModel{
    @Published var _state: AppViewState = empty
    static var empty: AppViewState = .empty
    
    private let userService: UserService
    private var currentUserSubscription: AnyCancellable?
    
    init(userService: UserService) {
        self.userService = userService
        addSubscription()
    }
    
    func addSubscription(){
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: {[weak self] receivedUser in
                self?._state = .init(shouldRenderAddChoreButton: receivedUser?.role == .parent || receivedUser?.role == .admin)
            })
    }
    
    var state: AnyPublisher<AppViewState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    func performAction(_ action: Void) {}
    
}

struct AppViewState{
    let shouldRenderAddChoreButton: Bool
    
    static let empty: AppViewState = .init(shouldRenderAddChoreButton: true)
}

extension Dependency.ViewModels{
    var appViewModel: AppViewModel{
        AppViewModel(userService: services.userService)
    }
}
