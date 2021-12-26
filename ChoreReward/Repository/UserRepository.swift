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
    @Published var user: User?
    @Published var users: [User] = []
        
    private let database = Firestore.firestore()
    
    init(
        initUser: User? = nil,
        initUsers: [User] = []
    ){
        self.user = initUser
        self.users = initUsers
    }
    
    //only user service should be able to create a user
    func createUser(newUser: User){
        guard let newUserId = newUser.id else{
            print("UserRepository: createUser: new user does not have an id")
            return
        }
        
        database.collection("users").document(newUserId).setData([
            "email": newUser.email,
            "name": newUser.name,
            "role": newUser.role.rawValue
        ]) { [weak self] err in
            if let err = err {
                print("UserRepository: createUser: Error adding user: \(err)")
            } else {
                self?.readUser(userId: newUserId)
                print("UserRepository: createUser: User added with ID: \(newUserId)")
            }
        }
    }
    
    func readUser(userId: String){
        database.collection("users").document(userId).getDocument {[weak self] (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let receivedUser):
                if let user = receivedUser {
                    self?.user = user
                } else {
                    print("UserRepository: readUser: User does not exist")
                }
            case .failure(let error):
                print("UserRepository: readUser: Error decoding user: \(error)")
            }
        }
    }
    
    func updateFamilyForUser(familyId: String, userId: String){
        database.collection("users").document(userId).updateData([
            "familyId" : familyId
        ]){ [weak self] err in
            self?.onUpdateComplettion(err: err, userId: userId)
        }
    }
    
    //split completion into a separate function to ensure readUser is called on all update
    private func onUpdateComplettion(err: Error?, userId: String) -> Void{
        if let err = err {
            print("UserRepository: onUpdateCompletion: Error updating user: \(err)")
        } else {
            readUser(userId: userId)
            print("UserRepository: onUpdateCompletion: User successfully updated")
        }
    }
    
    func readMultipleUsers(userIds: [String]){
        database.collection("users").whereField(FieldPath.documentID(), in: userIds)
            .getDocuments() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self?.users = querySnapshot!.documents.compactMap({ document in
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
