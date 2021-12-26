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
    
    private let currentUserRepository: UserRepository
    private let familyRepository: FamilyRepository
    private var currentFamilySubscription: AnyCancellable?
    private var currentUserSubscription: AnyCancellable?
    
    init(
        currentUserRepository: UserRepository,
        familyRepository: FamilyRepository,
        initCurrentFamily: Family? = nil
    ){
        self.currentUserRepository = currentUserRepository
        self.familyRepository = familyRepository
        self.currentFamily = initCurrentFamily
        addSubscription()
    }
    
    func addSubscription(){
        currentFamilySubscription = familyRepository.$family
            .sink(receiveValue: {[weak self] receivedFamily in
                self?.currentFamily = receivedFamily
            })
        currentUserSubscription = currentUserRepository.$user
            .sink(receiveValue: { [weak self] receivedUser in
                guard let currentFamilyId = receivedUser?.familyId else{
                    return
                }
                self?.readCurrentFamily(currentFamilyId: currentFamilyId)
            })
        
    }
    
    func createFamily(){
        guard let currentUserId = currentUserRepository.user?.id else{
            print("FamilyService: createFamily: cannot retrieve currentUserId")
            return
        }
        guard currentUserRepository.user?.role == .parent else{
            print("FamilyService: createFamily: user is not a parent")
            return
        }
        
        let newFamilyId = UUID().uuidString
        familyRepository.createFamily(currentUserId: currentUserId, newFamilyId: newFamilyId)
        currentUserRepository.updateFamilyForUser(
            familyId: newFamilyId,
            userId: currentUserId
        ) 
    }
    
    private func readCurrentFamily(currentFamilyId: String){
        familyRepository.readFamily(familyId: currentFamilyId)
    }
    
    func addCurrentUserToFamilyWithId(familyId: String){
        guard let currentUserId = currentUserRepository.user?.id else{
            print("FamilyService: addCurrentUserToFamilyWithId: cannot retrieve currentUserId")
            return
        }
        familyRepository.updateMemberOfFamily(
            familyId: familyId,
            userId: currentUserId
        )
        currentUserRepository.updateFamilyForUser(
            familyId: familyId,
            userId: currentUserId
        )
    }
    
    func addUserByIdToFamily(userId: String){
        guard let currentFamilyId = currentFamily?.id else {
            print ("FamilyService: addUserByIdToFamily: cannot retrieve currentFamilyId")
            return
        }
        
        familyRepository.updateMemberOfFamily(familyId: currentFamilyId, userId: userId)
        let userRepository = UserRepository()
        userRepository.updateFamilyForUser(familyId: currentFamilyId, userId: userId)
    }
}
