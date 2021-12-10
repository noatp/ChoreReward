//
//  FamilyTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/9/21.
//

import Foundation
import Combine

class FamilyTabViewModel: ObservableObject{
    @Published var familyId: String? = nil
    
    private let authService: AuthService
    private let userRepository: UserRepository
    private var userRepoSubscription: AnyCancellable?
    
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
                if let currentFamilyId = user?.familyId {
                    self?.familyId = currentFamilyId
                    return
                }
                self?.familyId = nil
            })
    }
    
    func getCurrentUserProfile(){
        userRepository.readUser(userId: authService.currentUid ?? "")
    }
}

extension Dependency.ViewModels{
    var familyTabViewModel: FamilyTabViewModel{
        return FamilyTabViewModel(
            authService: services.authService,
            userRepository: repositories.userRepository)
    }
}
