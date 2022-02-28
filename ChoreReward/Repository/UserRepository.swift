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

class UserDatabase {
    static let shared = UserDatabase()
    
    let userPublisher = PassthroughSubject<User, Never>()
    
    private let database = Firestore.firestore()
    var currentUserListener: ListenerRegistration?
    
    func readUser(userId: String) {
        guard currentUserListener == nil else {
            return
        }
        
        currentUserListener = database.collection("users").document(userId).addSnapshotListener { [weak self] documentSnapshot, error in
            if let error = error {
                print("UserDatabase: readUser: \(error)")
                return
            }

            guard let document = documentSnapshot else {
                print("UserDatabase: readUser: bad snapshot")
                return
            }

            let decodeResult = Result{
                try document.data(as: User.self)
            }
            switch decodeResult{
            case .success(let receivedUser):
                if let user = receivedUser{
                    print("UserDatabase: readUser: received new data from Firebase")
                    self?.userPublisher.send(user)
                }
                else{
                    print("UserDatabase: readUser: user does not exist")
                }
            case .failure(let error):
                print("UserDatabase: readUser: \(error)")
            }
        }
    }
}

class UserRepository: ObservableObject{
    private let database = Firestore.firestore()
    private let userDatabase = UserDatabase.shared
    
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
    
    func readUser(userId: String? = nil) -> AnyPublisher<User, Never>{
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
    
    func removeListener(){
        userDatabase.currentUserListener?.remove()
        userDatabase.currentUserListener = nil
    }
    
    enum RepositoryError: Error{
        case badSnapshot
    }
}
