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
    private let userDatabase : UserDatabase

    private let database = Firestore.firestore()
    
    init(userDatabase: UserDatabase) {
        self.userDatabase = userDatabase
    }
    
    func createUser(newUser: User) async {
        guard let newUserId = newUser.id else{
            print("UserRepository: createUser: new user does not have an id")
            return
        }
        
        do{
            try await database.collection("users").document(newUserId).setData([
                "email": newUser.email,
                "name": newUser.name,
                "role": newUser.role.rawValue,
                "profileImageUrl": newUser.profileImageUrl ?? NSNull()
            ])
        }
        catch{
            print("UserRepository: createUser: \(error)")
        }
    }
    
    func readUser(userId: String? = nil) -> AnyPublisher<User?, Never>{
        if let userId = userId {
            userDatabase.readUser(userId: userId)
        }
        return userDatabase.userPublisher.eraseToAnyPublisher()
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
    
    func updateRoleToAdminForUser(userId: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "role" : "admin"
            ])
        }
        catch{
            print("UserRepository updateRoleToAdminForUser: \(error)")
        }
    }
    
    func updateProfileImageForUser(userId: String, profileImageUrl: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "profileImageUrl" : profileImageUrl
            ])
        }
        catch{
            print("\(#function): \(error)")
        }
    }
    
    func updateUserProfileWithImage(userId: String, newUserProfileWithImage: User) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "email": newUserProfileWithImage.email,
                "name": newUserProfileWithImage.name,
                "profileImageUrl": newUserProfileWithImage.profileImageUrl ?? NSNull()
            ])
        }
        catch{
            print("\(#function): \(error)")
        }
    }
    
    func updateUserProfileWithoutImage(userId: String, newUserProfileWithoutImage: User) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "email": newUserProfileWithoutImage.email,
                "name": newUserProfileWithoutImage.name
            ])
        }
        catch{
            print("\(#function): \(error)")
        }
    }
    
    func resetRepository(){
        userDatabase.resetPublisher()
    }
    
    enum RepositoryError: Error{
        case badSnapshot
    }
}
