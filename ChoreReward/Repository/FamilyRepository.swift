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

class FamilyRepository{
    @Published var currentFamily: Family? = nil
        
    private let database = Firestore.firestore()
    
    init(initCurrentFamily: Family? = nil){
        self.currentFamily = initCurrentFamily
    }
    
    func createFamily(currentUserId: String, newFamilyId: String){
        let currentFamilyRef = database.collection("families").document(newFamilyId)
        currentFamilyRef.setData([
            "members": [currentUserId],
            "chores": []
        ]){ err in
            if let err = err {
                print("Error adding family: \(err)")
            } else {
                self.readCurrentFamily(currentFamilyId: newFamilyId)
                print("Family added with ID: \(newFamilyId)")
            }
        }
    }
    
    func readCurrentFamily(currentFamilyId: String){
        let currentFamilyRef = database.collection("families").document(currentFamilyId)
        currentFamilyRef.getDocument { [weak self] (document, error) in
            let result = Result {
                try document?.data(as: Family.self)
            }
            switch result {
            case .success(let receivedFamily):
                if let currentFamily = receivedFamily {
                    // A `user` value was successfully initialized from the DocumentSnapshot.
                    self?.currentFamily = currentFamily
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Family does not exist")
                }
            case .failure(let error):
                // A `user` value could not be initialized from the DocumentSnapshot.
                print("Error decoding family: \(error)")
            }
        }
    }
    
    func addUserToFamily(familyId: String, userId: String, onCompletion: @escaping (Error?) -> Void){
        let currentFamilyRef = database.collection("families").document(familyId)
        currentFamilyRef.updateData([
            "members" : FieldValue.arrayUnion([userId])
        ]){ err in
            onCompletion(err)
        }
    }
}
