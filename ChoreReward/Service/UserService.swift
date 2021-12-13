//
//  AuthenticationService.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import Foundation
import FirebaseAuth

class UserService: ObservableObject{
    @Published var authState: AuthState
    
    private let auth = Auth.auth()
    private let userRepository: UserRepository
    
    var currentUserid: String?{
        auth.currentUser?.uid
    }
    
    init(
        userRepository: UserRepository,
        initAuthState: AuthState = .signedOut(error: nil)
    ){
        self.userRepository = userRepository
        self.authState = initAuthState
    }
    
    func signIn(email: String, password: String){
        auth.signIn(
            withEmail: email,
            password: password
        ) {result, error in
            if (error != nil){
                self.authState = AuthState.signedOut(error: error)
            }
            else if (result != nil){
                self.signInIfCurrentUserExist()
            }
        }
    }
    
    func signUp(newUser: User, password: String){
        auth.createUser(
            withEmail: newUser.email,
            password: password
        ) { result, error in
            if (error != nil){
                self.authState = AuthState.signedOut(error: error)
            }
            else if (result != nil){
                let newUserWithId = User(
                    id: self.currentUserid!,
                    email: newUser.email,
                    name: newUser.name,
                    role: newUser.role
                )
                self.userRepository.createUser(newUser: newUserWithId)
                self.signInIfCurrentUserExist()
            }
        }
    }
    
    func signOut(){
        do {
            try self.auth.signOut()
            self.authState = AuthState.signedOut(error: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func signInIfCurrentUserExist(){
        guard let user = self.auth.currentUser else{
            return
        }
        authState = .signedIn
    }
    
    func readCurrentUser(){
        userRepository.readCurrentUser(currentUserId: currentUserid)
    }
    
    func readOtherUser(otherUserId: String){
        userRepository.readOtherUser(otherUserId: otherUserId)
    }
    
    enum AuthState{
        case signedIn
        case signedOut(error: Error?)
    }
}

