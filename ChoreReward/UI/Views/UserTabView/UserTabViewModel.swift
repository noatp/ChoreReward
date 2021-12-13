//
//  UserTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import Combine

class UserTabViewModel: ObservableObject{
    private var authService: AuthService
    
    private var userRepository: UserRepository
    private var userRepoSubscription: AnyCancellable?
    
    @Published var currentUserEmail: String = ""
    @Published var currentUserName: String = ""
    @Published var currentUserRole: String = ""
    
    init(
        authService: AuthService,
        userRepository: UserRepository
    ){
        self.authService = authService
        self.userRepository = userRepository
        self.addSubscription()
        self.getCurrentUserProfile()
    }
    
    func addSubscription(){
        userRepoSubscription = userRepository.$user
            .sink(receiveValue: { [weak self] user in
                self?.currentUserName = user?.name ?? ""
                self?.currentUserEmail = user?.email ?? ""
                self?.currentUserRole = user?.role.rawValue ?? ""
            })
    }
    
    func signOut(){
        authService.signOut()
    }
    
    func getCurrentUserProfile(){
        userRepository.readCurrentUser(currentUserId: authService.currentUid)
    }
    
    func getUserProfile(uid: String){
        userRepository.readOtherUser(otherUserId: uid)
    }
}

extension Dependency.ViewModels{
    var userTabViewModel: UserTabViewModel{
        UserTabViewModel(
            authService: services.authService,
            userRepository: repositories.userRepository
        )
    }
}
