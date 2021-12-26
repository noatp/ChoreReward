//
//  FamilyInvitationRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/25/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FamilyInvitationRepository: ObservableObject{
    @Published var invitationForCurrentUser: FamilyInvitation?
        
    private let database = Firestore.firestore()
    
    init(initFamilyInvitation: FamilyInvitation? = nil){
        self.invitationForCurrentUser = initFamilyInvitation
    }

    func createInvitation(invitation: FamilyInvitation){
        guard let invitee = invitation.id else{
            print("FamilyInvitationRepository: createInvitation: invitee is nil")
            return
        }
        
        database.collection("invitations").document(invitee).setData([
            "inviter": invitation.inviter,
            "toJoinFamily": invitation.toJoinFamily
        ]) { err in
            if let err = err {
                print("FamilyInvitationRepository: createInvitation: Error adding invitation: \(err)")
            } else {
                print("FamilyInvitationRepository: createInvitation: Invitation added for userId: \(invitee)")
            }
        }
    }
    
    func addListenerForInvitationToCurrentUser(currentUserId: String){
        database.collection("invitations").document(currentUserId)
            .addSnapshotListener { [weak self] documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("FamilyInvitationRepository: addListenerForInvitationToCurrentUser: Error fetching document: \(error!)")
                    return
                }
                let result = Result {
                    try document.data(as: FamilyInvitation.self)
                }
                switch result {
                case .success(let receivedInvitation):
                    if let invitationForCurrentUser = receivedInvitation {
                        print("FamilyInvitationRepository: addListenerForInvitationToCurrentUser: Current data: \(invitationForCurrentUser)")
                        self?.invitationForCurrentUser = invitationForCurrentUser
                    } else {
                        print("FamilyInvitationRepository: addListenerForInvitationToCurrentUser: Document data was empty.")
                    }
                case .failure(let error):
                    print("FamilyRepository: readCurrentFamily: Error decoding family: \(error)")
                }
            }
    }
    
}
