//
//  UserTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import Combine

class UserTabViewModel: StatefulViewModel{
    typealias State = UserTabState
    typealias Action = UserTabAction

    static let empty = UserTabState(currentUserEmail: "", currentUserName: "", currentUserRole: "")
    var state: AnyPublisher<UserTabState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    var action: Action{
        return Action(signOut: signOut)
    }
    
    private var userService: UserService
    private var currentUserSubscription: AnyCancellable?
    
    @Published var _state: UserTabState = empty
    
    init(
        userService: UserService
    ){
        self.userService = userService
        self.addSubscription()
    }
    
    func addSubscription(){
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                self?._state = .init(
                    currentUserEmail: receivedUser?.name ?? "",
                    currentUserName: receivedUser?.email ?? "",
                    currentUserRole: receivedUser?.role.rawValue ?? ""
                )
            })
    }
    
    func signOut(){
        userService.signOut()
    }
    
    
}

struct UserTabState: Equatable {
    let currentUserEmail: String
    let currentUserName: String
    let currentUserRole: String
}

struct UserTabAction{
    let signOut: () -> Void
}

extension Dependency.ViewModels{
    var userTabViewModel: UserTabViewModel{
        UserTabViewModel(
            userService: services.userService
        )
    }
}
