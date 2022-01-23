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
    let dependency: Dependency
    
    init(){
        FirebaseApp.configure()
        let currentUserRepository = UserRepository()
        let currentFamilyRepository = FamilyRepository()
        let currentChoreRepository = ChoreRepository()
        
        let userService = UserService(
            currentUserRepository: currentUserRepository
        )
        let familyService = FamilyService(
            currentUserRepository: currentUserRepository,
            currentFamilyRepository: currentFamilyRepository
        )
        let choreService = ChoreService(
            currentUserRepository: currentUserRepository,
            currentFamilyRepository: currentFamilyRepository,
            currentChoreRepository: currentChoreRepository
        )
        
        self.dependency = Dependency(
            userService: userService,
            familyService: familyService,
            choreService: choreService,
            currentUserRepository: currentUserRepository,
            currentFamilyRepository: currentFamilyRepository,
            currentChoreRepository: currentChoreRepository
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
