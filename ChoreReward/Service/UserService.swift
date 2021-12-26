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
 */

class UserService: ObservableObject{
    @Published var authState: AuthState
    @Published var currentUser: User?
    @Published var currentFamilyMembers: [User] = []
    
    private let auth = Auth.auth()
    private let currentUserRepository: UserRepository
    private let familyRepository: FamilyRepository
    
    private var currentUserSubscription: AnyCancellable?
    private var currentFamilySubscription: AnyCancellable?
    private var familyMemberSubscription: AnyCancellable?
    
    
    var currentUserId: String?{
        auth.currentUser?.uid
    }
    
    init(
        currentUserRepository: UserRepository,
        familyRepository: FamilyRepository,
        initAuthState: AuthState = .signedOut(error: nil)
    ){
        self.currentUserRepository = currentUserRepository
        self.authState = initAuthState
        self.familyRepository = familyRepository
        addSubscription()
    }
    
    func addSubscription(){
        currentUserSubscription = currentUserRepository.$user
            .sink(receiveValue: {[weak self] receivedUser in
                self?.currentUser = receivedUser
            })
        currentFamilySubscription = familyRepository.$family
            .sink(receiveValue: {[weak self] receivedFamily in
                guard let currentFamily = receivedFamily else{
                    return
                }
                self?.getMembersOfCurrentFamily(currentFamily: currentFamily)
            })
        familyMemberSubscription = currentUserRepository.$users
            .sink(receiveValue: {[weak self] receivedFamilyMembers in
                self?.currentFamilyMembers = receivedFamilyMembers
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
                    id: self.currentUserId!,
                    email: newUser.email,
                    name: newUser.name,
                    role: newUser.role
                )
                self.currentUserRepository.createUser(newUser: newUserWithId)
                self.signInIfCurrentUserExist()
            }
        }
    }
    
    func signOut(){
        do {
            try self.auth.signOut()
            resetRepositoryCache()
            self.authState = AuthState.signedOut(error: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func signInIfCurrentUserExist(){
        guard self.auth.currentUser != nil else{
            return
        }
        readCurrentUser()
        authState = .signedIn
    }
    
    func readCurrentUser(){
        guard let currentUserId = currentUserId else{
            print("UserService: readCurrentUser: trying to read current user but currentUserId is nil within this service instance")
            return
        }
        currentUserRepository.readUser(userId: currentUserId)
    }
    
    func getMembersOfCurrentFamily(currentFamily: Family){
        currentUserRepository.readMultipleUsers(userIds: currentFamily.members)
    }
    
    private func resetRepositoryCache(){
        currentUserRepository.user = nil
        familyRepository.family = nil
    }
    
    enum AuthState{
        case signedIn
        case signedOut(error: Error?)
    }
}

