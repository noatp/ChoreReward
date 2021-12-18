//
//  UserRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import CoreMedia

class UserRepository: ObservableObject{
    @Published var currentUser: User? = nil
    @Published var otherUser: User? = nil
    
    private var currentUserRef: DocumentReference? = nil
    
    private let database = Firestore.firestore()
    
    init(initCurrentUser: User? = nil){
        self.currentUser = initCurrentUser
    }
    
    //only user service should be able to create a user
    func createUser(newUser: User){
        guard let newUserId = newUser.id else{
            print("new user does not have an id")
            return
        }
        
        currentUserRef = database.collection("users").document(newUserId)
        
        currentUserRef!.setData([
            "email": newUser.email,
            "name": newUser.name,
            "role": newUser.role.rawValue
        ]) { err in
            if let err = err {
                print("Error adding user: \(err)")
            } else {
                self.readCurrentUser(currentUserId: newUserId)
                print("User added with ID: \(newUserId)")
            }
        }
    }
    
    func readCurrentUser(currentUserId: String? = nil){
        if (currentUserId == nil && currentUserRef == nil){
            print("there is no way to reference the user")
            return
        }
        
        if currentUserId != nil{
            currentUserRef = database.collection("users").document(currentUserId!)
        }
        
        currentUserRef!.getDocument {[weak self] (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let receivedUser):
                if let currentUser = receivedUser {
                    self?.currentUser = currentUser
                } else {
                    print("User does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func readOtherUser(otherUserId: String){
        database.collection("users").document(otherUserId).getDocument{[weak self] (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let receivedUser):
                if let otherUser = receivedUser {
                    self?.otherUser = otherUser
                } else {
                    print("User does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func updateFamilyForCurrentUser(familyId: String, currentUserId: String){
        currentUserRef = database.collection("users").document(currentUserId)
        currentUserRef?.updateData([
            "familyId" : familyId
        ]){ [weak self] err in
            if let err = err {
                print("Error updating user: \(err)")
            } else {
                print("User successfully updated")
                self?.readCurrentUser(currentUserId: currentUserId)
            }
        }
    }
}
