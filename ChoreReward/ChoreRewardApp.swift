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
    let userRepository: UserRepository
    let familyRepository: FamilyRepository
    let familyService: FamilyService
    let dependency: Dependency
    
    init(){
        FirebaseApp.configure()
        self.userRepository = UserRepository()
        self.familyRepository = FamilyRepository()
        self.userService = UserService(userRepository: self.userRepository, familyRepository: self.familyRepository)
        self.familyService = FamilyService(userRepository: self.userRepository, familyRepository: self.familyRepository)
        self.dependency = Dependency(
            userService: self.userService,
            userRepository: self.userRepository,
            familyRepository: self.familyRepository,
            familyService: self.familyService
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
