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
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        FirebaseApp.configure()
        let userRepository = UserRepository()
        let familyRepository = FamilyRepository()
        let choreRepository = ChoreRepository()
        let storageRepository = StorageRepository()
        
        let userService = UserService(
            currentUserRepository: userRepository,
            storageRepository:storageRepository
        )
        let familyService = FamilyService(
            userRepository: userRepository,
            familyRepository: familyRepository
        )
        let choreService = ChoreService(
            userRepository: userRepository,
            familyRepository: familyRepository,
            choreRepository: choreRepository,
            storageRepository: storageRepository
        )
        
        self.dependency = Dependency(
            userService: userService,
            familyService: familyService,
            choreService: choreService,
            currentUserRepository: userRepository,
            currentFamilyRepository: familyRepository,
            currentChoreRepository: choreRepository,
            storageRepository: storageRepository
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
