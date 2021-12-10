//
//  FamilyCreateViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/10/21.
//

import Foundation
import Combine

class FamilyCreateViewModel: ObservableObject{
    @Published var errorMessage: String? = nil
    
    private var currentUser: User? = nil
    private var currentFamily: Family? = nil
    
    private var authService: AuthService
    private var userRepository: UserRepository
    private var familyRepository: FamilyRepository
    private var userRepositorySubscription: AnyCancellable?
    private var familyRepositorySubscription: AnyCancellable?
    
    init(
        authService: AuthService,
        userRepository: UserRepository,
        familyRepository: FamilyRepository
    ){
        self.authService = authService
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        addSubscription()
        readCurrentUser()
    }

    func addSubscription(){
        userRepositorySubscription = userRepository.$user
            .sink(receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.userRepositorySubscription?.cancel()
            })
        
        familyRepositorySubscription = familyRepository.$currentFamily
            .sink(receiveValue: { [weak self] family in
                self?.currentFamily = family
            })
    }
    
    func createFamily(){
        guard currentUser != nil else{
            print("trying to create a new family but current user is nil")
            return
        }
        
        let newFamily = Family(
            id: nil,
            member: [currentUser!],
            chores: []
        )
        
        familyRepository.createFamily(newFamily: newFamily)
    }
    
    func readFamily(){
        guard currentUser != nil else{
            print("trying to read family but current user is nil")
            return
        }
        
        guard let familyId = currentUser!.familyId else{
            print("trying to read family but current user has nil familyId")
            return
        }
        
        familyRepository.readFamily(familyId: familyId)
    }
    
    private func readCurrentUser(){
        if let currentUid = authService.currentUid {
            userRepository.readUser(userId: currentUid)
        }
        else{
            print("can't read user because current uid from auth service is nil")
        }
    }
}

extension Dependency.ViewModels{
    var familyCreateViewModel: FamilyCreateViewModel{
        return FamilyCreateViewModel(
            authService: services.authService,
            userRepository: repositories.userRepository,
            familyRepository: repositories.familyRepository)
    }
}
