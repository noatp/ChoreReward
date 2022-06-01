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
    
    private var currentUserSubscription: AnyCancellable?
    private var currentFamilySubscription: AnyCancellable?
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository
    ){
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        addSubscription()
    }
    
    func addSubscription(){
        currentUserSubscription = userRepository.readUser()
            .sink(receiveValue: { [weak self] receivedUser in
                guard let currentUser = receivedUser else{
                    //logged out
                    self?.resetService()
                    return
                }
                print("\(#fileID) \(#function): received new user from UserDatabase through UserRepository")
                self?.readCurrentFamily(currentUser: currentUser)
            })
    }
    
    func createFamily(currentUser: User) async {
        guard let currentUserId = currentUser.id else{
            return
        }
        let newFamilyId = UUID().uuidString
        await familyRepository.createFamily(currentUser: currentUser, newFamilyId: newFamilyId)
        await userRepository.updateFamilyForUser(familyId: newFamilyId, userId: currentUserId)
        await userRepository.updateRoleToAdminForUser(userId: currentUserId)
    }
    
    func readCurrentFamily(currentUser: User) {
        guard let currentFamilyId = currentUser.familyId else{
            print("\(#fileID) \(#function): currentUser does not have a family")
            return
        }
        currentFamilySubscription = familyRepository.readFamily(familyId: currentFamilyId)
            .sink(receiveValue: { [weak self] receivedFamily in
                print("\(#fileID) \(#function): received new family from FamilyDatabse through FamilyRepository")
                self?.currentFamily = receivedFamily
//                self?.getMembersOfCurrentFamily(currentFamily: currentFamily)
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
    
//    private func getMembersOfCurrentFamily(currentFamily: Family) {
//        let memberIds = currentFamily.members
//        guard memberIds.count > 0, memberIds.count < 10 else{
//            return
//        }
//        Task{
//            currentFamilyMembers = await userRepository.readMultipleUsers(userIds: memberIds) ?? []
//        }
//    }
    
    private func resetService(){
        currentFamilySubscription?.cancel()
        currentFamilySubscription = nil
        currentFamily = nil
        familyRepository.resetRepository()
    }
}
