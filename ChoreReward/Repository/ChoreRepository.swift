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
    
    func createChore(newChore: Chore) -> String{
        return database.collection("chores").addDocument(data:[
            "title" : newChore.title,
            "assignerId": newChore.assignerId,
            "assigneeId": newChore.assigneeId
        ]).documentID
    }
        
    func readChore(choreId: String) async -> Chore?{
        do {
            let snapshot = try await database.collection("chores").document(choreId).getDocument()
            return try snapshot.data(as: Chore.self)
        }
        catch{
            print(error)
            return nil
        }
    }
    
    func readMultipleChores(choreIds: [String]) async -> [Chore]?{
        do{
            let querySnapshot = try await database.collection("chores")
                .whereField(FieldPath.documentID(), in: choreIds)
                .getDocuments()
            return try querySnapshot.documents.compactMap({ document in
                try document.data(as: Chore.self)
            })
        }
        catch{
            print("ChoreRepository: readMultipleChores: \(error)")
            return nil
        }
    }
}

