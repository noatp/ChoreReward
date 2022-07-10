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

    func create(_ newChore: Chore, with choreId: String, in choreCollection: CollectionReference) {
        do {
            _ = try choreCollection.document(choreId).setData(from: newChore)
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func read(_ choreCollection: CollectionReference) {
        if familyChoresListener == nil {
            familyChoresListener = choreCollection
                .order(by: "created")
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
                        print("\(#fileID) \(#function): received empty list, publishing empty list...")
                        self?.familyChoresPublisher.send([])
                    } else {
                        print("\(#fileID) \(#function): received chores data, publishing...")
                        self?.familyChoresPublisher.send(chores)
                    }
                }
        }
    }

    func update(choreAtId choreId: String, in choreCollection: CollectionReference, withAssignee assignee: DenormUser) {
        choreCollection
            .document(choreId)
            .updateData(
                ["assignee":
                    [
                        "id": assignee.id,
                        "name": assignee.name,
                        "userImageUrl": assignee.userImageUrl
                    ]
                ]) { error in
                if let error = error {
                    print("\(#fileID) \(#function): \(error)")
                }
            }
    }

    func update(finishedTimestampForChoreAtId choreId: String, in choreCollection: CollectionReference) {
        choreCollection
            .document(choreId)
            .updateData(["finished": Date.now.intTimestamp]) { error in
                if let error = error {
                    print("\(#fileID) \(#function): \(error)")
                }
            }
    }

    func update(choreAtId choreId: String, in choreCollection: CollectionReference, withImageUrl imageUrl: String) {
        choreCollection
            .document(choreId)
            .updateData(["choreImageUrl": imageUrl]) { error in
                if let error = error {
                    print("\(#fileID) \(#function): \(error)")
                }
            }
    }

    func delete(choreAtId choreId: String, in choreCollection: CollectionReference) {
        choreCollection
            .document(choreId)
            .delete()
    }

    func reset() {
        self.familyChoresPublisher.send(nil)
        self.familyChoresListener?.remove()
        self.familyChoresListener = nil
    }
}
