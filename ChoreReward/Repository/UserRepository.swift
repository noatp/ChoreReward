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
    
    func readUser(userId: String) -> AnyPublisher<User, Never>{
        return Future<User, Never>{ [weak self] promise in
            self?.database.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
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
                        promise(.success(user))
                    }
                    else{
                        print("UserRepository: readUser: user does not exist")
                    }
                case .failure(let error):
                    print("UserRepository: readUser: \(error)")
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
//    func readUser(userId: String) -> AnyPublisher<User, Error>{
//        do{
//            let documentSnapshot = try await database.collection("users").document(userId).getDocument()
//            return try documentSnapshot.data(as: User.self)
//        }
//        catch{
//            print("UserRepository: readUser: \(error)")
//            return nil
//        }
//        database.collection("users").document(userId)
//            .addSnapshotListener { [weak self] documentSnapshot, error in
//                guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                }
//                let result = Result {
//                    try document.data(as: User.self)
//                }
//                switch result {
//                case .success(let receivedUser):
//                    if let user = receivedUser {
//                        print("UserRepository: readUser: Received new data ", user)
//                        self?.user = user
//                    } else {
//                        print("UserRepository: readUser: User does not exist")
//                    }
//                case .failure(let error):
//                    print("UserRepository: readUser: Error decoding user: \(error)")
//                }
//            }
//        db.collection("cities").document("SF")
//            .addSnapshotListener { documentSnapshot, error in
//              guard let document = documentSnapshot else {
//                print("Error fetching document: \(error!)")
//                return
//              }
//              guard let data = document.data() else {
//                print("Document data was empty.")
//                return
//              }
//              print("Current data: \(data)")
//            }
//    }
    
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
    
    enum RepositoryError: Error{
        case badSnapshot
    }
}
