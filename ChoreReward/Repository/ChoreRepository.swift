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

class ChoreRepository: ObservableObject {
    private let database = Firestore.firestore()
    private var familyChoresListener: ListenerRegistration?
    let familyChoresPublisher = PassthroughSubject<[Chore]?, Never>()

    func createChore(newChore: Chore, newChoreId: String, choreCollection: CollectionReference?) {

        do {
            try choreCollection?.document(newChoreId).setData(from: newChore)
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func readChoreCollection(_ choreCollection: CollectionReference) {
        if familyChoresListener == nil {
            familyChoresListener = choreCollection.order(by: "created")
                .addSnapshotListener { [weak self] querySnapshot, error in
                    guard let querySnapshot = querySnapshot else {
                        print("\(#fileID) \(#function): Error fetching documents: \(error!)")
                        return
                    }
                    let chores: [Chore] = querySnapshot.documents
                        .compactMap { document in
                            do {
                                return try document.data(as: Chore.self)
                            } catch {
                                print("\(#fileID) \(#function): error")
                                return nil
                            }
                        }
                    if chores.isEmpty {
                        print("\(#fileID) \(#function): received empty list, publishing nil...")
                        self?.familyChoresPublisher.send(nil)
                    } else {
                        print("\(#fileID) \(#function): received chores data, publishing...")
                        self?.familyChoresPublisher.send(chores)
                    }
                }
        }
    }

    func updateAssigneeForChore(choreId: String, assigneeId: String, choreCollection: CollectionReference?) async {
        do {
            try await choreCollection?.document(choreId).updateData([
                "assigneeId": assigneeId
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func updateCompletionForChore(choreId: String, choreCollection: CollectionReference?) async {
        do {
            try await choreCollection?.document(choreId).updateData([
                "completed": Date.now.intTimestamp
            ])
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func resetRepository() {
        self.familyChoresPublisher.send(nil)
        self.familyChoresListener?.remove()
        self.familyChoresListener = nil
    }
}
