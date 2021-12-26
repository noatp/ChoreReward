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

class FamilyRepository: ObservableObject{
    @Published var family: Family? = nil
        
    private let database = Firestore.firestore()
    
    init(initFamily: Family? = nil){
        self.family = initFamily
    }
    
    func createFamily(currentUserId: String, newFamilyId: String){
        let currentFamilyRef = database.collection("families").document(newFamilyId)
        currentFamilyRef.setData([
            "admin": currentUserId,
            "members": [currentUserId],
            "chores": []
        ]){ [weak self] err in
            if let err = err {
                print("FamilyRepository: createFamily: Error adding family: \(err)")
            } else {
                self?.readFamily(familyId: newFamilyId)
                print("FamilyRepository: createFamily: Family added with ID: \(newFamilyId)")
            }
        }
    }
    
    func readFamily(familyId: String){
        let currentFamilyRef = database.collection("families").document(familyId)
        currentFamilyRef.getDocument { [weak self] (document, error) in
            let result = Result {
                try document?.data(as: Family.self)
            }
            switch result {
            case .success(let receivedFamily):
                if let currentFamily = receivedFamily {
                    self?.family = currentFamily
                } else {
                    print("FamilyRepository: readCurrentFamily: Family does not exist")
                }
            case .failure(let error):
                print("FamilyRepository: readCurrentFamily: Error decoding family: \(error)")
            }
        }
    }
    
    func updateMemberOfFamily(familyId: String, userId: String){
        let currentFamilyRef = database.collection("families").document(familyId)
        currentFamilyRef.updateData([
            "members" : FieldValue.arrayUnion([userId])
        ]){ err in
            if let err = err {
                print("FamilyRepository: addUserToFamily: Error updating family: \(err)")
            } else {
                print("FamilyRepository: addUserToFamily: Family successfully updated")
            }
        }
    }
}
