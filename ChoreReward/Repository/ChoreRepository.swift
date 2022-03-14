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

class ChoreRepository: ObservableObject{
    private let database = Firestore.firestore()
    private var currentChoreListener: ListenerRegistration?
    
    func createChore(newChore: Chore) -> String{
        return database.collection("chores").addDocument(data:[
            "title" : newChore.title,
            "assignerId": newChore.assignerId,
            "assigneeId": newChore.assigneeId,
            "created": Timestamp(date: newChore.created),
            "description": newChore.description
        ]).documentID
    }
    
    func readChore(choreId: String) async -> Chore?{
        do{
            let documentSnapshot = try await database.collection("chores").document(choreId).getDocument()
            return try documentSnapshot.data(as: Chore.self)
        }
        catch{
            print("ChoreRepository: readChore: \(error)")
            return nil
        }
    }
    
    func readMultipleChores(choreIds: [String]) async -> [Chore]?{
        do{
            let querySnapshot = try await database.collection("chores")
                .whereField(FieldPath.documentID(), in: choreIds)
                .getDocuments() //return at most 10
            return try querySnapshot.documents.compactMap({ document in
                try document.data(as: Chore.self)
            })
        }
        catch{
            print("ChoreRepository: readMultipleChores: \(error)")
            return nil
        }
    }
    
    func updateAssigneeForChore(choreId: String, assigneeId: String) async {
        do {
            try await database.collection("chores").document(choreId).updateData([
                "assigneeId" : assigneeId
            ])
        }
        catch{
            print("ChoreRepository: updateAssigneeForChore: \(error)")
        }
    }
    
    func updateCompletionForChore(choreId: String) async {
        do{
            try await database.collection("chores").document(choreId).updateData([
                "completed" : FieldValue.serverTimestamp()
            ])
        }
        catch{
            print("ChoreRepository: updateCompletionForChore: \(error)")
        }
    }
    
    func resetRepository(){
        self.currentChoreListener?.remove()
        self.currentChoreListener = nil
    }
}

