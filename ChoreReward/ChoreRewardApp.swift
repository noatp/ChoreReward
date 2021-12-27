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
    let currentUserRepository: UserRepository
    let currentFamilyRepository: FamilyRepository
    let familyService: FamilyService
    let dependency: Dependency
    
    init(){
        FirebaseApp.configure()
        self.currentUserRepository = UserRepository()
        self.currentFamilyRepository = FamilyRepository()
        self.userService = UserService(
            currentUserRepository: self.currentUserRepository
        )
        self.familyService = FamilyService(
            currentUserRepository: self.currentUserRepository,
            currentFamilyRepository: self.currentFamilyRepository
        )
        self.dependency = Dependency(
            userService: self.userService,
            currentUserRepository: self.currentUserRepository,
            currentFamilyRepository: self.currentFamilyRepository,
            familyService: self.familyService
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
