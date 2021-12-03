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
    @Published var user: [String: Any]? = nil
    
    private let database = Firestore.firestore()
    
    func createUser(
        userId: String,
        name: String?,
        email: String?
    ){
        database.collection("users").document(userId).setData([
            "email": email ?? "",
            "name": name ?? ""
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.readUser(userId: userId)
                print("Document added with ID: \(userId)")
            }
        }
    }
    
    func readUser(userId: String){
        let docRef = database.collection("users").document(userId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                self.user = document.data()
            } else {
                print("Document does not exist")
            }
        }

    }
}
