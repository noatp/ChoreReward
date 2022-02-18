//
//  AuthenticationService.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import Foundation
import FirebaseAuth
import Combine


/*
 NOTE TO SELF:
 - service should try to validate parameter before calling Repository
 
 script to remove all authentication
 setInterval(() => {
     document.getElementsByClassName('edit-account-button mat-focus-indicator mat-menu-trigger mat-icon-button mat-button-base')[0].click()
     let deleteButtonPosition = document.getElementsByClassName('mat-focus-indicator mat-menu-item ng-star-inserted').length - 1
     document.getElementsByClassName('mat-focus-indicator mat-menu-item ng-star-inserted')[deleteButtonPosition].click()
     document.getElementsByClassName('confirm-button mat-focus-indicator mat-raised-button mat-button-base mat-warn')[0].click()
 }, 1000)
 
 
 */

class UserService: ObservableObject{
    @Published var authState: AuthState = .signedOut(error: nil)
    @Published var currentUser: User?
    
    private let auth = Auth.auth()
    private let userRepository: UserRepository

    private var currentUserSubscription: AnyCancellable?
    private var isLoginPending: Bool = false
    
    var currentUserId: String?{
        auth.currentUser?.uid
    }
    
    init(
        currentUserRepository: UserRepository
    ){
        self.userRepository = currentUserRepository
    }
    
    private func performSignIn(){
        guard let currentUserId = currentUserId else{
            print("UserService: silentSignIn: trying to read current user but currentUserId is nil within this service instance")
            return
        }
        currentUserSubscription = userRepository.readUser(userId: currentUserId)
            .sink(receiveValue: {[weak self] receivedUser in
                print("UserService: silentSignIn: received new user \(receivedUser)")
                self?.currentUser = receivedUser
                self?.authState = .signedIn
            })
    }
    
    func silentSignIn() async {
        if isLoginPending == true {
            return
        }
        isLoginPending = true
        performSignIn()
    }
    
    func signIn(email: String, password: String) async {
        do{
            try await auth.signIn(withEmail: email, password: password)
            performSignIn()
        }
        catch{
            print("UserService: signIn: \(error)")
            authState = .signedOut(error: error)
        }
    }
    
    func signUp(newUser: User, password: String) async {
        do{
            try await auth.createUser(withEmail: newUser.email, password: password)
            let user = User(
                id: currentUserId,
                email: newUser.email,
                name: newUser.name,
                role: newUser.role
            )
            await userRepository.createUser(newUser: user)
            performSignIn()
        }
        catch{
            print("UserService: signUp: \(error)")
            authState = .signedOut(error: error)
        }
    }
    
    func signOut(){
        do {
            try self.auth.signOut()
            resetCache()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    func resetCache(){
//        currentUserSubscription?.cancel()
        currentUser = nil
        authState = .signedOut(error: nil)
        currentUserSubscription = nil
        userRepository.removeListener()
    }
    
    enum AuthState{
        case signedIn
        case signedOut(error: Error?)
    }
}

