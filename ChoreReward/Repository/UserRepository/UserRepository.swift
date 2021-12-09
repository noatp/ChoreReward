//
//  UserRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import CoreMedia

class UserRepository: ObservableObject{
    @Published var user: User? = nil
    
    private let database = Firestore.firestore()
    
    init(initUser: User? = nil){
        self.user = initUser
    }
    
    func createUser(newUser: User){
        database.collection("users").document(newUser.id ?? "").setData([
            "email": newUser.email,
            "name": newUser.name,
            "role": newUser.role.rawValue
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.readUser(userId: newUser.id ?? "")
                print("Document added with ID: \(newUser.id ?? "")")
            }
        }
    }
    
    func readUser(userId: String){
        let docRef = database.collection("users").document(userId)
        
        docRef.getDocument {[weak self] (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    // A `user` value was successfully initialized from the DocumentSnapshot.
                    self?.user = user
                } else {
                    // A nil value was successfully initialized from the DocumentSnapshot,
                    // or the DocumentSnapshot was nil.
                    print("Document does not exist")
                }
            case .failure(let error):
                // A `user` value could not be initialized from the DocumentSnapshot.
                print("Error decoding user: \(error)")
            }
        }
    }
}
