//
//  FamilyRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import CoreMedia

class FamilyRepository: ObservableObject {
    @Published var currentFamily: Family?

    private let database = Firestore.firestore()
    private var currentFamilyRef: DocumentReference?

    init(initFamily: Family? = nil) {
        self.currentFamily = initFamily
    }

    func createFamily(newFamily: Family) {
        guard currentFamilyRef == nil else {
            return
        }
        currentFamilyRef = database.collection("families").addDocument(data: [
            "members": newFamily.members,
            "chores": newFamily.chores
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.readFamily(familyId: self.currentFamilyRef!.documentID)
                print("Document added with ID: \(self.currentFamilyRef!.documentID)")
            }
        }
    }

    func readFamily(familyId: String) {
        if currentFamilyRef == nil {
            currentFamilyRef = database.collection("families").document(familyId)
        }

        guard currentFamilyRef != nil else {
            print("can't find reference to the family with provided id")
            return
        }

        currentFamilyRef!.getDocument {[weak self] (document, error) in
            let result = Result {
                try document?.data(as: Family.self)
            }
            switch result {
            case .success(let family):
                if let family = family {
                    // A `user` value was successfully initialized from the DocumentSnapshot.
                    self?.currentFamily = family
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `user` value could not be initialized from the DocumentSnapshot.
                print("Error decoding family: \(error)")
            }
        }
    }
}
