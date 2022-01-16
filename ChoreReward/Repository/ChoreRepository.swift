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
    
    
//    //split completion into a separate function to ensure readUser is called on all write operation
//    private func onWriteCompletion(err: Error?, userId: String) -> Void{
//        if let err = err {
//            print("UserRepository: onWriteCompletion: Error writing to user: \(err)")
//        } else {
//            readUser(userId: userId)
//            print("UserRepository: onWriteCompletion: Successfully write to user with ID \(userId)")
//        }
//    }
        
}

