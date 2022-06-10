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

class UserRepository: ObservableObject {
    private let userDatabase: UserDatabase

    private let database = Firestore.firestore()

    init(userDatabase: UserDatabase) {
        self.userDatabase = userDatabase
    }

    func create(_ newUser: User) {
        guard let newUserId = newUser.id else {
            print("\(#fileID) \(#function): new user does not have an id")
            return
        }

        do {
            try database.collection("users").document(newUserId).setData(from: newUser)
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func readUser(userId: String? = nil) -> AnyPublisher<User?, Never> {
        if let userId = userId {
            userDatabase.readUser(userId: userId)
        }
        return userDatabase.userPublisher.eraseToAnyPublisher()
    }

    func readMultipleUsers(userIds: [String]) async -> [User]? {
        do {
            let querySnapshot = try await database.collection("users")
                .whereField(FieldPath.documentID(), in: userIds)
                .getDocuments()
            return try querySnapshot.documents.compactMap { document in
                try document.data(as: User.self)
            }
        } catch {
            print("\(#fileID) \(#function): \(error)")
            return nil
        }
    }

    func updateFamilyForUser(familyId: String, userId: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "familyId": familyId
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func updateRoleToAdminForUser(userId: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "role": "admin"
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func updateProfileImageForUser(userId: String, profileImageUrl: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "profileImageUrl": profileImageUrl
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func updateProfileForUser(with userId: String, using newUserProfile: User) {
        do {
            try database.collection("users").document(userId).setData(from: newUserProfile, merge: true)
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func updateUserImage(for userId: String, with imageUrl: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "userImageUrl": imageUrl
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func resetRepository() {
        userDatabase.resetPublisher()
    }
}
