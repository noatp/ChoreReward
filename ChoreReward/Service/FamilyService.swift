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
                print("FamilyService: addSubscription: received new user from UserDatabase through UserRepository")
                self?.readCurrentFamily(currentUser: receivedUser)
            })
    }
    
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
        currentFamilySubscription = familyRepository.readFamily(familyId: currentFamilyId)
            .sink(receiveValue: { [weak self] receivedFamily in
                print("FamilyService: readCurrentFamily: received new family from FamilyDatabse through FamilyRepository")
                self?.currentFamily = receivedFamily
                self?.getMembersOfCurrentFamily(currentFamily: receivedFamily)
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
    
    private func getMembersOfCurrentFamily(currentFamily: Family) {
        let memberIds = currentFamily.members
        guard memberIds.count > 0, memberIds.count < 10 else{
            return
        }
        Task{
            currentFamilyMembers = await userRepository.readMultipleUsers(userIds: memberIds) ?? []
        }
    }
    
    func resetCache(){
        currentFamilySubscription?.cancel()
        currentFamily = nil
        currentFamilyMembers = []
        currentFamilySubscription = nil
        familyRepository.removeListener()
    }
}
