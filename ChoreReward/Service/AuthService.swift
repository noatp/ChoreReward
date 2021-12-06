//
//  AuthenticationService.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import Foundation
import FirebaseAuth

class AuthService: ObservableObject{
    let auth = Auth.auth()
    let userRepository: UserRepository
    
    var currentUid: String?{
        auth.currentUser?.uid
    }
    
    init(userRepository: UserRepository){
        self.userRepository = userRepository
    }
    
    @Published var authState = AuthState.signedOut(error: nil)
    
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
                self.userRepository.createUser(
                    userId: self.currentUid ?? "",
                    name: newUser.name,
                    email: newUser.email
                )
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
        authState = .signedIn(
            currentUser: user
        )
    }
    
    enum AuthState{
        case signedIn(currentUser: FirebaseAuth.User)
        case signedOut(error: Error?)
    }
}

