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
    
    private let userRepository: UserRepository
    private let familyRepository: FamilyRepository
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository
    ){
        self.userRepository = userRepository
        self.familyRepository = familyRepository
    }
    
//    func addSubscription(){
//        currentFamilySubscription = currentFamilyRepository.$family
//            .sink(receiveValue: {[weak self] receivedFamily in
//                self?.currentFamily = receivedFamily
//                guard let currentFamily = receivedFamily else{
//                    return
//                }
//                self?.getMembersOfCurrentFamily(currentFamily: currentFamily)
//            })
//        currentUserSubscription = currentUserRepository.$user
//            .sink(receiveValue: { [weak self] receivedUser in
//                guard receivedUser != nil else{
//                    self?.resetFamilyCache()
//                    return
//                }
//                guard let currentFamilyId = receivedUser?.familyId else{
//                    return
//                }
//                self?.readCurrentFamily(currentFamilyId: currentFamilyId)
//            })
//        familyMemberSubscription = currentUserRepository.$users
//            .sink(receiveValue: {[weak self] receivedFamilyMembers in
//                self?.currentFamilyMembers = receivedFamilyMembers
//            })
//
//    }
    
    func createFamily(currentUser: User) async {
        guard let currentUserId = currentUser.id else{
            return
        }
        let newFamilyId = UUID().uuidString
        await familyRepository.createFamily(currentUserId: currentUserId, newFamilyId: newFamilyId)
        await userRepository.updateFamilyForUser(familyId: newFamilyId, userId: currentUserId)
    }
    
    func readCurrentFamily(currentFamilyId: String) async {
        currentFamily = await familyRepository.readFamily(familyId: currentFamilyId)
    }
    
    
    func addUserToCurrentFamily(userId: String) async {
        guard let currentFamilyId = currentFamily?.id else{
            return
        }
        guard userId != "" else{
            return
        }
        
        await familyRepository.updateMemberOfFamily(familyId: currentFamilyId, userId: userId)
        await userRepository.updateFamilyForUser(familyId: currentFamilyId, userId: userId)
    }
    
    func getMembersOfCurrentFamily(currentFamily: Family) async {
        currentFamilyMembers = await userRepository.readMultipleUsers(userIds: currentFamily.members) ?? []
    }
    
    func isCurrentUserAdminOfCurrentFamily() -> Bool{
//        guard let adminId = currentFamily?.admin,
//              let currentUserId = currentUserRepository.user?.id else{
//                  print ("FamilyService: isCurrentUserAdminOfCurrentFamily: can't get adminId or currentUserId")
//                  return false
//              }
//        return adminId == currentUserId
        return true
    }
}
