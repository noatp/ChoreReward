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
    let authService: AuthService
    let userRepository: UserRepository
    let dependency: Dependency
    
    init(){
        FirebaseApp.configure()
        self.userRepository = UserRepository()
        self.authService = AuthService(userRepository: self.userRepository)
        self.dependency = Dependency(
            authService: self.authService,
            userRepository: self.userRepository
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(views: Dependency.preview.views())
        }
    }
}
