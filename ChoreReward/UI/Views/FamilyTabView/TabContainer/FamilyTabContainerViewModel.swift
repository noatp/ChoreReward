//
//  FamilyTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import Combine

class FamilyTabContainerViewModel: ObservableObject{
    private let authService: AuthService
    private let userRepository: UserRepository
    private var userRepoSubscription: AnyCancellable?
    
    @Published var hasFamily: Bool = false
    
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
                guard user?.familyId != nil else{
                    self?.hasFamily = false
                    return
                }
                self?.hasFamily = true
            })
    }
    
    func getCurrentUserProfile(){
        userRepository.readUser(userId: authService.currentUid ?? "")
    }
}

extension Dependency.ViewModels{
    var familyTabContainerViewModel: FamilyTabContainerViewModel{
        FamilyTabContainerViewModel(
            authService: services.authService,
            userRepository: repositories.userRepository
        )
    }
}
