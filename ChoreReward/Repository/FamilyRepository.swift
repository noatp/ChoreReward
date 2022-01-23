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
    private let database = Firestore.firestore()
    
    func createFamily(currentUserId: String, newFamilyId: String) async {
        do{
            try await database.collection("families").document(newFamilyId).setData([
                "admin": currentUserId,
                "members": [currentUserId],
                "chores": []
            ])
        }
        catch{
            print("FamilyRepository: createFamily: \(error)")
        }
        
    }
    
    func readFamily(familyId: String) async -> Family?{
        do{
            let documentSnapshot = try await database.collection("families").document(familyId).getDocument()
            return try documentSnapshot.data(as: Family.self)
        }
        catch{
            print("FamilyRepository: readFamily: \(error)")
            return nil
        }
    }
    
    func updateMemberOfFamily(familyId: String, userId: String) async {
        do{
            try await database.collection("families").document(familyId).updateData([
                "members" : FieldValue.arrayUnion([userId])
            ])
        }
        catch{
            print("FamilyRepository: updateMemberOfFamily: \(error)")
        }
    }
    
    func updateChoreOfFamily(familyId: String, choreId: String) async {
        do{
            try await database.collection("families").document(familyId).updateData([
                "chores" : FieldValue.arrayUnion([choreId])
            ])
        }
        catch{
            print("FamilyRepository: updateChoreOfFamily: \(error)")
        }
    }
}
