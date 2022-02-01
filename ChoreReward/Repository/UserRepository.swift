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
    private var currentUserListener: ListenerRegistration?
    
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
    
    func readUser(userId: String) -> AnyPublisher<User, Never>{
        let publisher = PassthroughSubject<User, Never>()
        currentUserListener = database.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                print("UserRepository: readUser: \(error)")
                return
            }

            guard let document = documentSnapshot else {
                print("UserRepository: readUser: bad snapshot")
                return
            }

            let decodeResult = Result{
                try document.data(as: User.self)
            }
            switch decodeResult{
            case .success(let receivedUser):
                if let user = receivedUser{
                    print("UserRepository: readUser: received new data ", user)
                    publisher.send(user)
                }
                else{
                    print("UserRepository: readUser: user does not exist")
                }
            case .failure(let error):
                print("UserRepository: readUser: \(error)")
            }

        }
        return publisher.eraseToAnyPublisher()
    }
    
    func readMultipleUsers(userIds: [String]) async -> [User]?{
        guard userIds.count > 0, userIds.count < 10 else {
            return nil
        }
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
        currentUserListener?.remove()
        currentUserListener = nil
    }
    
    enum RepositoryError: Error{
        case badSnapshot
    }
}
