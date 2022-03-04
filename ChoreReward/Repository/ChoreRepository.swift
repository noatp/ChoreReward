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
            "completed": newChore.completed
        ]).documentID
    }
    
    func readChore(choreId: String) -> AnyPublisher<Chore, Never>{
        let publisher = PassthroughSubject<Chore, Never>()
        currentChoreListener = database.collection("chores").document(choreId).addSnapshotListener({ documentSnapshot, error in
                if let error = error {
                    print("ChoreRepository: readChore: \(error)")
                    return
                }
                
                guard let document = documentSnapshot else {
                    print("ChoreRepository: readChore: bad snapshot")
                    return
                }
                
                let decodeResult = Result{
                    try document.data(as: Chore.self)
                }
                switch decodeResult{
                case .success(let receivedChore):
                    if let chore = receivedChore{
                        print("ChoreRepository: readChore: received new data")
                        publisher.send(chore)
                    }
                    else{
                        print("ChoreRepository: readChore: chore does not exist")
                    }
                    
                case .failure(let error):
                    print("ChoreRepository: readChore: \(error)")
                }
            })
        return publisher.eraseToAnyPublisher()
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
    
    func resetRepository(){
        self.currentChoreListener?.remove()
        self.currentChoreListener = nil
    }
}

