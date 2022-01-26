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
        let userRepository = UserRepository()
        let familyRepository = FamilyRepository()
        let choreRepository = ChoreRepository()
        
        let userService = UserService(
            currentUserRepository: userRepository
        )
        let familyService = FamilyService(
            userRepository: userRepository,
            familyRepository: familyRepository
        )
        let choreService = ChoreService(
            userRepository: userRepository,
            familyRepository: familyRepository,
            choreRepository: choreRepository
        )
        let serviceManager = ServiceManager(
            userSerivce: userService,
            familyService: familyService,
            choreService: choreService
        )
        
        
        self.dependency = Dependency(
            userService: userService,
            familyService: familyService,
            choreService: choreService,
            currentUserRepository: userRepository,
            currentFamilyRepository: familyRepository,
            currentChoreRepository: choreRepository,
            serviceManager: serviceManager
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
