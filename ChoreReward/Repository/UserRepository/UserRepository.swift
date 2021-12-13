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
    
    private var currentUserRef: DocumentReference? = nil
    
    private let database = Firestore.firestore()
    private var currentUserId: String? = nil
    
    init(initUser: User? = nil){
        self.user = initUser
    }
    
    func createUser(newUser: User){
        guard let newUserId = newUser.id else{
            print("new user does not have an id")
            return
        }
        
        currentUserRef = database.collection("users").document(newUserId)
        
        currentUserRef!.setData([
            "email": newUser.email,
            "name": newUser.name,
            "role": newUser.role.rawValue
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.readCurrentUser(currentUserId: newUserId)
                print("User added with ID: \(newUserId)")
            }
        }
    }
    
    func readCurrentUser(currentUserId: String? = nil){
        if (currentUserId == nil && currentUserRef == nil){
            print("there is no way to reference the user")
            return
        }
        
        if currentUserId != nil{
            currentUserRef = database.collection("users").document(currentUserId!)
        }
        
        currentUserRef!.getDocument {[weak self] (document, error) in
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
                    print("User does not exist")
                }
            case .failure(let error):
                // A `user` value could not be initialized from the DocumentSnapshot.
                print("Error decoding user: \(error)")
            }
        }
    }
    
    func readOtherUser(otherUserId: String){
        
    }
}
