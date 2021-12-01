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

final class UserRepository: ObservableObject{
    private let userDB = Firestore.firestore()
    
    func createUser(
        userId: String,
        name: String,
        email: String
    ){
        userDB.collection("users").document(userId).setData([
            "email": email,
            "name": name
        ])
        userDB.collection("users").document(userId).setData([
            "email": email,
            "name": name
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(userId)")
            }
        }
    }
}
