//
//  FamilyTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/9/21.
//

import Foundation
import Combine

class FamilyTabViewModel: ObservableObject{
    @Published var currentFamily: Family? = nil
    private var currentUser: User? = nil
    
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
        self.readCurrentUser()
    }
    
    func addSubscription(){
        userRepositorySubscription = userRepository.$user
            .sink(receiveValue: { [weak self] user in
                guard user != nil else{
                    return
                }
                self?.currentUser = user
                if (self?.currentUser?.familyId == nil){
                    self?.createFamily()
                }
                else{
                    print("HERE2")
                    self?.readFamily()
                }
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
            members: [currentUser!.id!],
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
    var familyTabViewModel: FamilyTabViewModel{
        return FamilyTabViewModel(
            authService: services.authService,
            userRepository: repositories.userRepository,
            familyRepository: repositories.familyRepository)
    }
}
