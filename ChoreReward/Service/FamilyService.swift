//
//  FamilyService.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/13/21.
//

import Foundation
import Combine

class FamilyService: ObservableObject{
    @Published var currentFamily: Family? = nil
    
    private let userRepository: UserRepository
    private let familyRepository: FamilyRepository
    private var currentFamilySubscription: AnyCancellable?
    private var currentUserSubscription: AnyCancellable?
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository,
        initCurrentFamily: Family? = nil
    ){
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.currentFamily = initCurrentFamily
        addSubscription()
    }
    
    func addSubscription(){
        currentFamilySubscription = familyRepository.$currentFamily
            .sink(receiveValue: {[weak self] receivedFamily in
                self?.currentFamily = receivedFamily
            })
        currentUserSubscription = userRepository.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                guard let currentFamilyId = receivedUser?.familyId else{
                    print("current user does not have a family id")
                    return
                }
                self?.readCurrentFamily(currentFamilyId: currentFamilyId)
            })
        
    }
    
    func createFamily(){
        guard let currentUserId = userRepository.currentUser?.id else{
            print("cannot retrieve currentUserId")
            return
        }
        
        let newFamilyId = UUID().uuidString
        familyRepository.createFamily(currentUserId: currentUserId, newFamilyId: newFamilyId)
        userRepository.updateFamilyForCurrentUser(
            familyId: newFamilyId,
            currentUserId: currentUserId
        ) 
    }
    
    func readCurrentFamily(currentFamilyId: String){
        familyRepository.readCurrentFamily(currentFamilyId: currentFamilyId)
    }
    
    func addCurrentUserToFamilyWithId(familyId: String){
        guard let currentUserId = userRepository.currentUser?.id else{
            print("cannot retrieve currentUserId")
            return
        }
        familyRepository.addUserToFamily(
            familyId: familyId,
            userId: currentUserId
        ) { [weak self] err in
            if let err = err {
                print("Error updating family: \(err)")
            } else {
                print("Family successfully updated")
                self?.userRepository.updateFamilyForCurrentUser(
                    familyId: familyId,
                    currentUserId: currentUserId
                )
            }
        }
    }
    
    func addUserWithIdToCurrentFamily(userId: String){
        
    }
}
