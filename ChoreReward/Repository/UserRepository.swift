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
    @Published var currentUser: User?
    @Published var otherUser: User?
    @Published var currentFamilyMembers: [User] = []
        
    private let database = Firestore.firestore()
    
    init(
        initCurrentUser: User? = nil,
        initOtherUser: User? = nil,
        initcurrentFamilyMemebers: [User] = []
    ){
        self.currentUser = initCurrentUser
        self.otherUser = initOtherUser
        self.currentFamilyMembers = initcurrentFamilyMemebers
    }
    
    //only user service should be able to create a user
    func createUser(newUser: User){
        guard let newUserId = newUser.id else{
            print("UserRepository: createUser: new user does not have an id")
            return
        }
        
        let currentUserRef = database.collection("users").document(newUserId)
        
        currentUserRef.setData([
            "email": newUser.email,
            "name": newUser.name,
            "role": newUser.role.rawValue
        ]) { [weak self] err in
            if let err = err {
                print("UserRepository: createUser: Error adding user: \(err)")
            } else {
                self?.readCurrentUser(currentUserId: newUserId)
                print("UserRepository: createUser: User added with ID: \(newUserId)")
            }
        }
    }
    
    func readCurrentUser(currentUserId: String){
        let currentUserRef = database.collection("users").document(currentUserId)
        currentUserRef.getDocument {[weak self] (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let receivedUser):
                if let currentUser = receivedUser {
                    self?.currentUser = currentUser
                } else {
                    print("UserRepository: readCurrentUser: User does not exist")
                }
            case .failure(let error):
                print("UserRepository: readCurrentUser: Error decoding user: \(error)")
            }
        }
    }
    
    func readOtherUser(otherUserId: String){
        let otherUserRef = database.collection("users").document(otherUserId)
        otherUserRef.getDocument{[weak self] (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let receivedUser):
                if let otherUser = receivedUser {
                    self?.otherUser = otherUser
                } else {
                    print("UserRepository: readOtherUser: User does not exist")
                }
            case .failure(let error):
                print("UserRepository: readOtherUser: Error decoding user: \(error)")
            }
        }
    }
    
    func updateFamilyForCurrentUser(familyId: String, currentUserId: String){
        let  currentUserRef = database.collection("users").document(currentUserId)
        currentUserRef.updateData([
            "familyId" : familyId
        ]){ [weak self] err in
            self?.onUpdateComplettion(err: err, currentUserId: currentUserId)
        }
    }
    
    //split completion into a separate function to ensure readCurrentUser is called on all update
    private func onUpdateComplettion(err: Error?, currentUserId: String) -> Void{
        if let err = err {
            print("UserRepository: onUpdateCompletion: Error updating user: \(err)")
        } else {
            readCurrentUser(currentUserId: currentUserId)
            print("UserRepository: onUpdateCompletion: User successfully updated")
        }
    }
    
    func readMultipleUsers(userIds: [String]){
        database.collection("users").whereField(FieldPath.documentID(), in: userIds)
            .getDocuments() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self?.currentFamilyMembers = querySnapshot!.documents.compactMap({ document in
                        let result = Result{
                            try document.data(as: User.self)
                        }
                        switch result{
                        case .success(let receivedUser):
                            guard let user = receivedUser else{
                                return nil
                            }
                            return user
                        case .failure(let error):
                            print("UserRepository: readMultipleUser: Error decoding user: \(error)")
                            return nil
                        }
                    })
                }
            }
    }
}
