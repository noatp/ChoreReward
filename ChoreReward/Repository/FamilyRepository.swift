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

class FamilyRepository: ObservableObject {
    private let database = Firestore.firestore()
    private var currentFamilyListener: ListenerRegistration?
    let familyPublisher = PassthroughSubject<Family?, Never>()

    /*
     first create a family with empty 'members' array.
     then update the 'members' array, adding the admin "userId" as the first member of the family.
     the update will trigger cloud function to update the correspoding user document
     the user document will have role updated to "admin" and new familyId
     */
    func createFamily(currentUserId: String) async {
        let newFamilyDocRef: DocumentReference = database.collection("families").document()
        let newFamily: Family = .init(
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

    func readFamily(familyId: String) {
        if currentFamilyListener == nil {
            currentFamilyListener = database.collection("families")
                .document(familyId)
                .addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("\(#fileID) \(#function): Error fetching document: \(error!)")
                        return
                    }
                    do {
                        var family = try document.data(as: Family.self)
                        family.familyDocRef = document.reference
                        print("\(#fileID) \(#function): received family data, publishing...")
                        self?.familyPublisher.send(family)
                    } catch {
                        print("\(#fileID) \(#function): error decoding \(error)")
                    }
                }
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

    func reset() {
        self.familyPublisher.send(nil)
        self.currentFamilyListener?.remove()
        self.currentFamilyListener = nil
    }
}
