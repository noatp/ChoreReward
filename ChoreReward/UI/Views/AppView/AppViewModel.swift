//
//  AppViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/27/21.
//

import Foundation
import Combine

class AppViewModel: ObservableObject{
    private var authService: AuthService
    
    private var userRepository: UserRepository
    private var userRepoSubscription: AnyCancellable?
    
    @Published var currentUserEmail: String = ""
    @Published var currentUserName: String = ""

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
            })
    }
    
    func signOut(){
        authService.signOut()
    }
    
    func getCurrentUserProfile(){
        userRepository.readUser(userId: authService.currentUid ?? "")
    }
    
    func getUserProfile(uid: String){
        userRepository.readUser(userId: uid)
    }
}

extension Dependency.ViewModels{
    var appViewModel: AppViewModel{
        AppViewModel(
            authService: services.authService,
            userRepository: repositories.userRepository
        )
    }
    
    
}
