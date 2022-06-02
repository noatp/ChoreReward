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
                    print("\(#fileID) \(#function): addSnapshotListener error: \(error)")
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
                    print("\(#fileID) \(#function): received data from Firebase")
                    self?.familyPublisher.send(receivedFamily)
                case .failure(let error):
                    print("\(#fileID) \(#function): decoding error: \(error)")
                }
            }
        )
    }

    func resetPublisher() {
        currentFamilyListener?.remove()
        currentFamilyListener = nil
        self.familyPublisher.send(nil)
    }
}

class FamilyRepository: ObservableObject {
    private let database = Firestore.firestore()
    private let familyDatabase = FamilyDatabase.shared

    /*
     first create a family with empty 'members' array.
     then update the 'members' array, adding the admin "userId" as the first member of the family.
     the update will trigger cloud function to update the correspoding user document
     the user document will have role updated to "admin" and new familyId
     */
    func createFamily(currentUserId: String) async {
        let newFamilyDocRef: DocumentReference = database.collection("families").document()
        let newFamily: Family = .init(
            familyDocRef: newFamilyDocRef,
            adminId: currentUserId,
            members: []
        )
        do {
            let data = try Firestore.Encoder().encode(newFamily)
            try await newFamilyDocRef.setData(data)
            await updateMembersOfFamily(familyId: newFamilyDocRef.documentID, userId: currentUserId)
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }

    }

    func readFamily(familyId: String) -> AnyPublisher<Family?, Never> {
        familyDatabase.readFamily(familyId: familyId)
        return familyDatabase.familyPublisher.eraseToAnyPublisher()
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
        familyDatabase.resetPublisher()
    }
}
