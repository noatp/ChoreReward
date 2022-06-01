//
//  ChoreRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/14/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

//class ChoreDatabase {
//    static let shared = ChoreDatabase()
//
//
//    private let database = Firestore.firestore()
//    private var currentFamilyListener: ListenerRegistration?
//
//    func readFamily(familyId: String){
//        family.choreCollection?.addSnapshotListener({ [weak self] querySnapshot, error in
//            guard let documents = querySnapshot?.documents else{
//                print("Error fetching documents: \(error!)")
//                return
//            }
//
//
//        })
//    }
//
//    func resetPublisher(){
//        self.familyPublisher.send(nil)
//    }
//}

class ChoreRepository: ObservableObject{
    private let database = Firestore.firestore()
    private var familyChoresListener: ListenerRegistration?
    private var choreCollection: CollectionReference?
    let familyChoresPublisher = PassthroughSubject<[Chore]?, Never>()
    
    func createChore(newChore: Chore, newChoreId: String){
        do{
            try choreCollection?.document(newChoreId).setData(from: newChore)
        }
        catch{
            print("\(#fileID) \(#function): \(error)")
        }
    }
    
    func readChore(choreId: String) async -> Chore?{
        do{
            let documentSnapshot = try await database.collection("chores").document(choreId).getDocument()
            return try documentSnapshot.data(as: Chore.self)
        }
        catch{
            print("\(#fileID) \(#function): \(error)")
            return nil
        }
    }
    
    func readChoresOfFamily(_ family: Family) {
        choreCollection = family.choreCollection
        if familyChoresListener == nil {
            familyChoresListener = family.choreCollection?.addSnapshotListener{ [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else{
                    print("\(#fileID) \(#function): Error fetching documents: \(error!)")
                    return
                }
                let chores: [Chore] = documents.compactMap{ document in
                    do {
                        return try document.data(as: Chore.self)
                    }
                    catch{
                        print("\(#fileID) \(#function): error")
                        return nil
                    }
                }
                self?.familyChoresPublisher.send(chores)
            }
        }
    }
    
    func updateAssigneeForChore(choreId: String, assigneeId: String) async {
        do {
            try await database.collection("chores").document(choreId).updateData([
                "assigneeId" : assigneeId
            ])
        }
        catch{
            print("\(#fileID) \(#function): \(error)")
        }
    }
    
    func updateCompletionForChore(choreId: String) async {
        do{
            try await database.collection("chores").document(choreId).updateData([
                "completed" : FieldValue.serverTimestamp()
            ])
        }
        catch{
            print("\(#fileID) \(#function): \(error)")
        }
    }
    
    func resetRepository(){
        self.familyChoresPublisher.send(nil)
        self.familyChoresListener?.remove()
        self.familyChoresListener = nil
    }
}

