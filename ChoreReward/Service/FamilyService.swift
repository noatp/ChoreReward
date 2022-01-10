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
    @Published var currentFamilyMembers: [User] = []
    
    private let currentUserRepository: UserRepository
    private let currentFamilyRepository: FamilyRepository
    
    private var currentFamilySubscription: AnyCancellable?
    private var currentUserSubscription: AnyCancellable?
    private var familyMemberSubscription: AnyCancellable?
    
    init(
        currentUserRepository: UserRepository,
        currentFamilyRepository: FamilyRepository
    ){
        self.currentUserRepository = currentUserRepository
        self.currentFamilyRepository = currentFamilyRepository
        addSubscription()
    }
    
    func addSubscription(){
        currentFamilySubscription = currentFamilyRepository.$family
            .sink(receiveValue: {[weak self] receivedFamily in
                self?.currentFamily = receivedFamily
                guard let currentFamily = receivedFamily else{
                    return
                }
                self?.getMembersOfCurrentFamily(currentFamily: currentFamily)
            })
        currentUserSubscription = currentUserRepository.$user
            .sink(receiveValue: { [weak self] receivedUser in
                guard receivedUser != nil else{
                    self?.resetFamilyCache()
                    return
                }
                guard let currentFamilyId = receivedUser?.familyId else{
                    return
                }
                self?.readCurrentFamily(currentFamilyId: currentFamilyId)
            })
        familyMemberSubscription = currentUserRepository.$users
            .sink(receiveValue: {[weak self] receivedFamilyMembers in
                self?.currentFamilyMembers = receivedFamilyMembers
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
        currentFamilyRepository.createFamily(currentUserId: currentUserId, newFamilyId: newFamilyId)
        currentUserRepository.updateFamilyForUser(
            familyId: newFamilyId,
            userId: currentUserId
        ) 
    }
    
    private func readCurrentFamily(currentFamilyId: String){
        currentFamilyRepository.readFamily(familyId: currentFamilyId)
    }
    
    func addCurrentUserToFamilyWithId(familyId: String){
        guard let currentUserId = currentUserRepository.user?.id else{
            print("FamilyService: addCurrentUserToFamilyWithId: cannot retrieve currentUserId")
            return
        }
        currentFamilyRepository.updateMemberOfFamily(
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
        
        guard userId != "" else{
            return
        }
        
        currentFamilyRepository.updateMemberOfFamily(familyId: currentFamilyId, userId: userId)
        let userRepository = UserRepository()
        userRepository.updateFamilyForUser(familyId: currentFamilyId, userId: userId)
    }
    
    func getMembersOfCurrentFamily(currentFamily: Family){
        currentUserRepository.readMultipleUsers(userIds: currentFamily.members)
    }
    
    func isCurrentUserAdminOfCurrentFamily() -> Bool{
        guard let adminId = currentFamily?.admin,
              let currentUserId = currentUserRepository.user?.id else{
                  print ("FamilyService: isCurrentUserAdminOfCurrentFamily: can't get adminId or currentUserId")
                  return false
              }
        return adminId == currentUserId
    }
    
    func resetFamilyCache(){
        currentFamilyRepository.resetCache()
    }
}
