//
//  UserTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import Combine

class UserTabViewModel: StatefulViewModel{
    
    static let empty = UserTabState(
        currentUserEmail: "",
        currentUserName: "",
        currentUserRole: ""
    )
    
    @Published var _state: UserTabState = empty
    var state: AnyPublisher<UserTabState, Never>{
        return $_state.eraseToAnyPublisher()
    }

    private var userService: UserService
    private var currentUserSubscription: AnyCancellable?
        
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
                    currentUserEmail: receivedUser?.email ?? "",
                    currentUserName: receivedUser?.name ?? "",
                    currentUserRole: receivedUser?.role.rawValue ?? ""
                )
            })
    }
    
    func signOut(){
        userService.signOut()
    }
    
    func performAction(_ action: UserTabAction) {
        switch(action){
            case .signOut:
                self.signOut()
        }
    }
}

struct UserTabState {
    let currentUserEmail: String
    let currentUserName: String
    let currentUserRole: String
}

enum UserTabAction{
    case signOut
}

extension Dependency.ViewModels{
    var userTabViewModel: UserTabViewModel{
        UserTabViewModel(
            userService: services.userService
        )
    }
}
