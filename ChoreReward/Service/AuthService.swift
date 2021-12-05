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
    let userRepository = UserRepository()
    
    var currentUid: String?{
        auth.currentUser?.uid
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
                self.authState = AuthState.signedIn(
                    currentUser: self.auth.currentUser!,
                    newUser: false
                )
            }
            //is there anyway to return the data directly in this completion???
        }
    }
    
    func signUp(email: String, password: String){
        auth.createUser(
            withEmail: email,
            password: password
        ) { result, error in
            if (error != nil){
                self.authState = AuthState.signedOut(error: error)
            }
            else if (result != nil){
                self.authState = AuthState.signedIn(
                    currentUser: self.auth.currentUser!,
                    newUser: true
                )
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
    
    func silentAuth(){
        guard let user = self.auth.currentUser else{
            return
        }
        authState = .signedIn(
            currentUser: user,
            newUser: false
        )
    }
    
    enum AuthState{
        case signedIn(currentUser: FirebaseAuth.User, newUser: Bool)
        case signedOut(error: Error?)
    }
}

