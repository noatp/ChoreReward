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
        database.collection("families").document(newFamilyId).setData([
            "admin": currentUserId,
            "members": [currentUserId],
            "chores": []
        ]){ [weak self] err in
            self?.onWriteCompletion(err: err, familyId: currentUserId)
        }
    }
    
    func readFamily(familyId: String){
        database.collection("families").document(familyId).getDocument { [weak self] (document, error) in
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
        database.collection("families").document(familyId).updateData([
            "members" : FieldValue.arrayUnion([userId])
        ]){ [weak self] err in
            self?.onWriteCompletion(err: err, familyId: familyId)
        }
    }
    
    //split completion into a separate function to ensure readFamily is called on all write operation
    private func onWriteCompletion(err: Error?, familyId: String) -> Void{
        if let err = err {
            print("FamilyRepository: onWriteCompletion: Error writing to family: \(err)")
        } else {
            readFamily(familyId: familyId)
            print("FamilyRepository: onWriteCompletion: Successfully write to family with ID: \(familyId)")
        }
    }

    
    func resetCache(){
        family = nil
    }
}
