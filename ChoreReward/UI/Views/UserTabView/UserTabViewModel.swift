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
    
    private var userRepository: UserRepository
    private var userRepoSubscription: AnyCancellable?
    
    @Published var currentUserEmail: String = ""
    @Published var currentUserName: String = ""
    @Published var currentUserRole: String = ""
    
    init(
        userService: UserService,
        userRepository: UserRepository
    ){
        self.userService = userService
        self.userRepository = userRepository
        self.addSubscription()
        self.getCurrentUserProfile()
    }
    
    func addSubscription(){
        userRepoSubscription = userRepository.$currentUser
            .sink(receiveValue: { [weak self] user in
                self?.currentUserName = user?.name ?? ""
                self?.currentUserEmail = user?.email ?? ""
                self?.currentUserRole = user?.role.rawValue ?? ""
            })
    }
    
    func signOut(){
        userService.signOut()
    }
    
    func getCurrentUserProfile(){
        userRepository.readCurrentUser(currentUserId: userService.currentUserid)
    }
    
    func getUserProfile(uid: String){
        userRepository.readOtherUser(otherUserId: uid)
    }
}

extension Dependency.ViewModels{
    var userTabViewModel: UserTabViewModel{
        UserTabViewModel(
            userService: services.userService,
            userRepository: repositories.userRepository
        )
    }
}
