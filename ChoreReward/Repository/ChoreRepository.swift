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
    @Published var choreList: [Chore] = []
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
    
    func readMultipleChores(choreIds: [String]){
        guard choreIds.count > 0 else{
            return
        }
        database.collection("chores").whereField(FieldPath.documentID(), in: choreIds)
            .getDocuments { [weak self] querySnapshot, err in
                if let err = err {
                    print("UserRepository: readMultipleUser: Error getting documents: \(err)")
                } else {
                    self?.choreList = querySnapshot!.documents.compactMap({ document in
                        let result = Result{
                            try document.data(as: Chore.self)
                        }
                        switch result{
                        case .success(let receivedChore):
                            guard let chore = receivedChore else{
                                return nil
                            }
                            return chore
                        case .failure(let error):
                            print("UserRepository: readMultipleUser: Error decoding user: \(error)")
                            return nil
                        }
                    })
                }
            }
    }
    
    func resetCache(){
        choreList = []
    }
}

