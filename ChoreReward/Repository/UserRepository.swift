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

    func updateFamilyForUser(familyId: String, userId: String) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "familyId": familyId
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func updateProfileForUser(with userId: String, using newUserProfile: User) {
        database.collection("users").document(userId).updateData([
            "name": newUserProfile.name,
            "email": newUserProfile.email,
            "userImageUrl": newUserProfile.userImageUrl ?? NSNull()
        ]) { error in
            if let error = error {
                print("\(#fileID) \(#function): \(error)")
            }
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
