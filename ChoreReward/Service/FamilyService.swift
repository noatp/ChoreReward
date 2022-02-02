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
    
    private var currentFamilySubscription: AnyCancellable?
    
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
        await userRepository.updateRoleToAdminForUser(userId: currentUserId)
    }
    
    func readCurrentFamily(currentUser: User) {
        guard let currentFamilyId = currentUser.familyId else{
            print("FamilyService: readCurrentFamily: currentUser does not have a family")
            return
        }
        print("FamilyService: readCurrentFamily: initiate reading")
        currentFamilySubscription = familyRepository.readFamily(familyId: currentFamilyId)
            .sink(receiveValue: { [weak self] receivedFamily in
                print("FamilyService: readCurrentFamily: received new family")
                self?.currentFamily = receivedFamily
            })
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
        let memberIds = currentFamily.members
        guard memberIds.count > 0, memberIds.count < 10 else{
            return
        }
        currentFamilyMembers = await userRepository.readMultipleUsers(userIds: memberIds) ?? []
    }
    
    func resetCache(){
        currentFamilySubscription?.cancel()
        currentFamily = nil
        currentFamilyMembers = []
        currentFamilySubscription = nil
        familyRepository.removeListener()
    }
}
