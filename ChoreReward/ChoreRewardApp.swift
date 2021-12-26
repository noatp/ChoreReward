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
    let familyRepository: FamilyRepository
    let familyService: FamilyService
    let familyInvitationRepository: FamilyInvitationRepository
    let dependency: Dependency
    
    init(){
        FirebaseApp.configure()
        self.currentUserRepository = UserRepository()
        self.familyRepository = FamilyRepository()
        self.familyInvitationRepository = FamilyInvitationRepository()
        self.userService = UserService(
            currentUserRepository: self.currentUserRepository,
            familyRepository: self.familyRepository
        )
        self.familyService = FamilyService(
            userRepository: self.currentUserRepository,
            familyRepository: self.familyRepository,
            familyInvitationRepository: self.familyInvitationRepository
        )
        self.dependency = Dependency(
            userService: self.userService,
            userRepository: self.currentUserRepository,
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
