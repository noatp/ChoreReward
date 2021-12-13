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
    let dependency: Dependency
    
    init(){
        FirebaseApp.configure()
        self.userRepository = UserRepository()
        self.userService = UserService(userRepository: self.userRepository)
        self.dependency = Dependency(
            userService: self.userService,
            userRepository: self.userRepository
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: self.dependency.views())
        }
    }
}
