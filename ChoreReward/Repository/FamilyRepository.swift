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
    private var currentFamilyListener: ListenerRegistration?
    
    init(){
        print("FUCK")
    }
    
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
    
    func readFamily(familyId: String) -> AnyPublisher<Family, Never>{
        let publisher = PassthroughSubject<Family, Never>()
        currentFamilyListener = database.collection("families").document(familyId).addSnapshotListener({ documentSnapshot, error in
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
                        publisher.send(family)
                    }
                    else{
                        print("FamilyRepository: readFaily: family does not exist")
                    }
                    
                case .failure(let error):
                    print("FamilyRepository: readFamily: \(error)")
                }
            })
        return publisher.eraseToAnyPublisher()
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
        currentFamilyListener?.remove()
        currentFamilyListener = nil
    }
}
