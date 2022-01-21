//
//  ChoreRewardApp.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/23/21.
//

import SwiftUI
import Firebase

@main
struct ChoreRewardApp: App {
    let userService: UserService
    let familyService: FamilyService
    let choreService: ChoreService
    
    let currentUserRepository: UserRepository
    let currentFamilyRepository: FamilyRepository
    let currentChoreRepository: ChoreRepository
    let dependency: Dependency
    
    init(){
        FirebaseApp.configure()
        self.currentUserRepository = UserRepository()
        self.currentFamilyRepository = FamilyRepository()
        self.currentChoreRepository = ChoreRepository()
        
        self.userService = UserService(
            currentUserRepository: self.currentUserRepository
        )
        self.familyService = FamilyService(
            currentUserRepository: self.currentUserRepository,
            currentFamilyRepository: self.currentFamilyRepository
        )
        self.choreService = ChoreService(
            currentUserRepository: currentUserRepository,
            currentFamilyRepository: currentFamilyRepository,
            currentChoreRepository: currentChoreRepository
        )
        
        self.dependency = Dependency(
            userService: self.userService,
            familyService: self.familyService,
            choreService: self.choreService,
            currentUserRepository: self.currentUserRepository,
            currentFamilyRepository: self.currentFamilyRepository,
            currentChoreRepository: self.currentChoreRepository
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
