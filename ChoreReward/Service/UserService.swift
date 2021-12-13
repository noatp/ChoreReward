//
//  AuthenticationService.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import Foundation
import FirebaseAuth
import Combine

class UserService: ObservableObject{
    @Published var authState: AuthState
    @Published var currentUser: User? = nil
    @Published var otherUser: User? = nil
    
    private let auth = Auth.auth()
    private let userRepository: UserRepository
    private var currentUserSubscription: AnyCancellable?
    private var otherUserSubscription: AnyCancellable?
    
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
    
    func addSubscription(){
        currentUserSubscription = userRepository.$currentUser
            .sink(receiveValue: {[weak self] receivedUser in
                self?.currentUser = receivedUser
            })
        otherUserSubscription = userRepository.$otherUser
            .sink(receiveValue: {[weak self] receivedUser in
                self?.otherUser = receivedUser
            })
        
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

