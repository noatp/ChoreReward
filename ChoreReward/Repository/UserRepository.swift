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

class UserRepository: ObservableObject{
    private let database = Firestore.firestore()
    
    func createUser(newUser: User) async {
        guard let newUserId = newUser.id else{
            print("UserRepository: createUser: new user does not have an id")
            return
        }
        
        do{
            try await database.collection("users").document(newUserId).setData([
                "email": newUser.email,
                "name": newUser.name,
                "role": newUser.role.rawValue
            ])
        }
        catch{
            print("UserRepository: createUser: \(error)")
        }
    }
    
    func readUser(userId: String) async -> User?{
        do{
            let documentSnapshot = try await database.collection("users").document(userId).getDocument()
            return try documentSnapshot.data(as: User.self)
        }
        catch{
            print("UserRepository: readUser: \(error)")
            return nil
        }
    }
    
    func readMultipleUsers(userIds: [String]) async -> [User]?{
        do {
            let querySnapshot = try await database.collection("users")
                .whereField(FieldPath.documentID(), in: userIds)
                .getDocuments()
            return try querySnapshot.documents.compactMap { document in
                try document.data(as: User.self)
            }
        }
        catch{
            print("UserRepository: readMultipleUsers: \(error)")
            return nil
        }
    }
    
    func updateFamilyForUser(familyId: String, userId: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "familyId" : familyId
            ])
        }
        catch{
            print("UserRepository: updateFamilyForUser: \(error)")
        }
    }
}
