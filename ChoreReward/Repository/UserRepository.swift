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
    private let database = Firestore.firestore()
    private var currentUserListener: ListenerRegistration?
    let userPublisher = PassthroughSubject<User?, Never>()

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

    func readUser(userId: String) {
        if currentUserListener == nil {
            currentUserListener = database.collection("users")
                .document(userId)
                .addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("\(#fileID) \(#function): Error fetching document: \(error!)")
                        return
                    }
                    do {
                        var user = try document.data(as: User.self)
                        // could get a reference to the user doc here for use later in family service
                        user.userDocRef = document.reference
                        print("\(#fileID) \(#function): received user data, publishing...")
                        self?.userPublisher.send(user)
                    } catch {
                        print("\(#fileID) \(#function): error decoding \(error)")
                    }
                }
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

    func updateUserFCMToken(for userId: String, with token: String?) async {
        do {
            try await database.collection("users").document(userId).updateData([
                "fcmToken": token ?? NSNull()
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func resetRepository() {
        self.userPublisher.send(nil)
        self.currentUserListener?.remove()
        self.currentUserListener = nil
    }
}
