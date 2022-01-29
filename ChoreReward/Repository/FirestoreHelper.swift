////
////  FirestoreHelper.swift
////  ChoreReward
////
////  Created by Toan Pham on 1/28/22.
////
//
//import Foundation
//import Combine
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//struct FirestoreSubscription<Model> where Model: Decodable {
//    private var listener: Listener
//    private struct Listener {
//      let document: DocumentReference
//      let listener: ListenerRegistration
//      let subject: PassthroughSubject<Model, Never>
//    }
//
//    static func subscribe(id: AnyHashable, docPath: String) -> AnyPublisher<Model, Never> {
//        let publisher = PassthroughSubject<Model, Never>()
//
//        let docRef = Firestore.firestore().document(docPath)
//        listener = docRef.addSnapshotListener { documentSnapshot, error in
//            if let error = error {
//                print("FirestoreSubscription: subscribe: \(error)");
//                return
//            }
//
//            guard let document = documentSnapshot else{
//                print("FirestoreSubscription: subscribe: bad snapshot");
//            }
//
//            let decodeResult = Result{
//                try document.data(as: Model.self)
//            }
//
//            switch decodeResult {
//            case .success(let receivedData):
//                if let data = receivedData {
//                    print("FirestoreSubscription: subscribe: received new data \(data)")
//                    publisher.send(data)
//                }
//                else{
//                    print("FirestoreSubscription: subscribe: data does not exist")
//                }
//            case .failure(let error):
//                print("FirestoreSubscription: subscribe: \(error)")
//            }
//        }
//
//    listener = Listener(document: docRef, listener: listener, subject: publisher)
//
//    return publisher.eraseToAnyPublisher()
//  }
//
//  static func cancel() {
//    listener.remove()
//    listeners[id]?.subject.send(completion: .finished)
//    listeners[id] = nil
//  }
//}
//
//
