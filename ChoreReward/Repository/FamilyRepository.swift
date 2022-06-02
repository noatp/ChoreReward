//
//  FamilyRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/12/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class FamilyDatabase {
    static let shared = FamilyDatabase()

    let familyPublisher = PassthroughSubject<Family?, Never>()

    private let database = Firestore.firestore()
    var currentFamilyListener: ListenerRegistration?

    func readFamily(familyId: String) {
        guard currentFamilyListener == nil else {
            return
        }

        currentFamilyListener = database.collection("families").document(familyId).addSnapshotListener({ [weak self] documentSnapshot, error in
                if let error = error {
                    print("\(#fileID) \(#function): \(error)")
                    return
                }

                guard let document = documentSnapshot else {
                    print("\(#fileID) \(#function): bad snapshot")
                    return
                }

                let decodeResult = Result {
                    try document.data(as: Family.self)
                }
                switch decodeResult {
                case .success(let receivedFamily):
                    print("\(#fileID) \(#function): received new data from Firebase")
                    self?.familyPublisher.send(receivedFamily)
                case .failure(let error):
                    print("\(#fileID) \(#function): \(error)")
                }
            }
        )
    }

    func resetPublisher() {
        self.familyPublisher.send(nil)
    }
}

class FamilyRepository: ObservableObject {
    private let database = Firestore.firestore()
    private let familyDatabase = FamilyDatabase.shared

    // when writing the members field of family => trigger cloud function to update familyId of user
    func createFamily(currentUser: User) async {
        guard let currentUserId = currentUser.id else {
            return
        }
        let newFamilyDocRef: DocumentReference = database.collection("families").document()
        let newFamily: Family = .init(
            familyDocRef: newFamilyDocRef,
            adminId: currentUserId,
            members: []
        )
        do {
            try newFamilyDocRef.setData(from: newFamily)
            await updateMembersOfFamily(familyId: newFamilyDocRef.documentID, userId: currentUserId)
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }

    }

    func readFamily(familyId: String? = nil) -> AnyPublisher<Family?, Never> {
        if let familyId = familyId {
            familyDatabase.readFamily(familyId: familyId)
        }
        return familyDatabase.familyPublisher.eraseToAnyPublisher()
    }

    func updateChoreOfFamily(familyId: String, choreId: String) async {
        do {
            try await database.collection("families").document(familyId).updateData([
                "chores": FieldValue.arrayUnion([choreId])
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func updateMembersOfFamily(familyId: String, userId: String) async {
        do {
            try await database.collection("families").document(familyId).updateData([
                "members": FieldValue.arrayUnion([
                    ["id": userId]
            ])
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func resetRepository() {
        familyDatabase.currentFamilyListener?.remove()
        familyDatabase.currentFamilyListener = nil
        familyDatabase.resetPublisher()
    }
}
