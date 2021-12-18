//
//  UserTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import Combine

class UserTabViewModel: ObservableObject{
    private var userService: UserService
    private var currentUserSubscription: AnyCancellable?
    
    @Published var currentUserEmail: String = ""
    @Published var currentUserName: String = ""
    @Published var currentUserRole: String = ""
    
    init(
        userService: UserService
    ){
        self.userService = userService
        self.addSubscription()
    }
    
    func addSubscription(){
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                self?.currentUserName = receivedUser?.name ?? ""
                self?.currentUserEmail = receivedUser?.email ?? ""
                self?.currentUserRole = receivedUser?.role.rawValue ?? ""
            })
    }
    
    func signOut(){
        userService.signOut()
    }
    
    func getUserProfile(uid: String){
        userService.readOtherUser(otherUserId: uid)
    }
}

extension Dependency.ViewModels{
    var userTabViewModel: UserTabViewModel{
        UserTabViewModel(
            userService: services.userService
        )
    }
}
