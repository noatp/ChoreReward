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
    
    let familyPublisher = PassthroughSubject<Family, Never>()
    
    private let database = Firestore.firestore()
    var currentFamilyListener: ListenerRegistration?
    
    func readFamily(familyId: String){
        guard currentFamilyListener == nil else{
            return
        }
        
        currentFamilyListener = database.collection("families").document(familyId).addSnapshotListener({ [weak self] documentSnapshot, error in
                if let error = error {
                    print("FamilyRepository: readFamily: \(error)")
                    return
                }
                
                guard let document = documentSnapshot else {
                    print("UserRepository: readuser: bad snapshot")
                    return
                }
                
                let decodeResult = Result{
                    try document.data(as: Family.self)
                }
                switch decodeResult{
                case .success(let receivedFamily):
                    if let family = receivedFamily{
                        print("FamilyRepository: readFamily: received new data ", family)
                        self?.familyPublisher.send(family)
                    }
                    else{
                        print("FamilyRepository: readFaily: family does not exist")
                    }
                    
                case .failure(let error):
                    print("FamilyRepository: readFamily: \(error)")
                }
            }
        )
    }
}


class FamilyRepository: ObservableObject{
    private let database = Firestore.firestore()
    private let familyDatabase = FamilyDatabase.shared
    
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
    
    func readFamily(familyId: String? = nil) -> AnyPublisher<Family, Never>{
        if let familyId = familyId {
            familyDatabase.readFamily(familyId: familyId)
        }
        return familyDatabase.familyPublisher.eraseToAnyPublisher()
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
    
    func removeListener(){
        familyDatabase.currentFamilyListener?.remove()
        familyDatabase.currentFamilyListener = nil
    }
}
