//
//  UserDatabase.swift
//  ChoreReward
//
//  Created by Toan Pham on 5/21/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserDatabase {    
    let userPublisher = PassthroughSubject<User?, Never>()
    
    private let database = Firestore.firestore()
    private var currentUserListener: ListenerRegistration?
    
    func readUser(userId: String) {
        guard currentUserListener == nil else {
            return
        }
        
        currentUserListener = database.collection("users").document(userId).addSnapshotListener { [weak self] documentSnapshot, error in
            if let error = error {
                print("\(#fileID) \(#function): \(error)")
                return
            }
            
            guard let document = documentSnapshot else {
                print("\(#fileID) \(#function): bad snapshot")
                return
            }
                        
            let decodeResult = Result{
                try document.data(as: User.self)
            }
            switch decodeResult{
            case .success(let receivedUser):
                print("\(#fileID) \(#function): received user data from Firebase")
                self?.userPublisher.send(receivedUser)
            case .failure(let error):
                print("\(#fileID) \(#function): \(error)")
            }
        }
    }
    
    func resetPublisher(){
        self.userPublisher.send(nil)
        self.currentUserListener?.remove()
        self.currentUserListener = nil
    }
}

class MockUserDatabase: UserDatabase{
    let mockUser: User?
    
    init(mockUser: User? = nil) {
        self.mockUser = mockUser
    }
    
    override func readUser(userId: String) {
        guard let mockUser = mockUser else {
            return
        }
        userPublisher.send(mockUser)
    }
    
}


