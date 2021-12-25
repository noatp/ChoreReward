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
    private let familyInvitationRepository: FamilyInvitationRepository
    private var currentFamilySubscription: AnyCancellable?
    private var currentUserSubscription: AnyCancellable?
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository,
        familyInvitationRepository: FamilyInvitationRepository,
        initCurrentFamily: Family? = nil
    ){
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.familyInvitationRepository = familyInvitationRepository
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
                guard let currentFamilyId = receivedUser?.familyId,
                      let currentUserId = receivedUser?.id
                else{
                    return
                }
                self?.readCurrentFamily(currentFamilyId: currentFamilyId)
                self?.addListenToInvite(userId: currentUserId)
            })
        
    }
    
    func createFamily(){
        guard let currentUserId = userRepository.currentUser?.id else{
            print("FamilyService: createFamily: cannot retrieve currentUserId")
            return
        }
        guard userRepository.currentUser?.role == .parent else{
            print("FamilyService: createFamily: user is not a parent")
            return
        }
        
        let newFamilyId = UUID().uuidString
        familyRepository.createFamily(currentUserId: currentUserId, newFamilyId: newFamilyId)
        userRepository.updateFamilyForCurrentUser(
            familyId: newFamilyId,
            currentUserId: currentUserId
        ) 
    }
    
    private func readCurrentFamily(currentFamilyId: String){
        familyRepository.readCurrentFamily(currentFamilyId: currentFamilyId)
    }
    
    func addCurrentUserToFamilyWithId(familyId: String){
        guard let currentUserId = userRepository.currentUser?.id else{
            print("FamilyService: addCurrentUserToFamilyWithId: cannot retrieve currentUserId")
            return
        }
        familyRepository.addUserToFamily(
            familyId: familyId,
            userId: currentUserId
        )
        userRepository.updateFamilyForCurrentUser(
            familyId: familyId,
            currentUserId: currentUserId
        )
    }
    
    func addUserWithIdToCurrentFamily(userId: String){
        
    }
    
    func inviteUserJoinCurrentFamily(userId: String){
        guard let currentFamily = currentFamily?.id else {
            print("FamilyService: inviteUserJoinCurrentFamily: currentFamily is nil")
            return
        }
        
        guard let currentUserId = userRepository.currentUser?.id else{
            print("FamilyService: inviteUserJoinCurrentFamily: cannot retrieve currentUserId")
            return
        }
        
        let newInvitation = FamilyInvitation(
            id: userId,
            inviter: currentUserId,
            toJoinFamily: currentFamily
        )
        
        familyInvitationRepository.createInvitation(invitation: newInvitation)
    }
    
    func addListenToInvite(userId: String){
        familyInvitationRepository.addListenerForInvitationToCurrentUser(currentUserId: userId)
    }
}
