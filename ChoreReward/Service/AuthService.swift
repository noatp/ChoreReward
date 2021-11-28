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
                self.authState = AuthState.signedIn(currentUser: self.auth.currentUser!)
            }
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
                self.authState = AuthState.signedIn(currentUser: self.auth.currentUser!)
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
    
    enum AuthState{
        case signedIn(currentUser: FirebaseAuth.User)
        case signedOut(error: Error?)
    }
}
