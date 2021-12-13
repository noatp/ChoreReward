//
//  Dependency.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/28/21.
//

import Foundation
import UIKit

class Dependency{
    let userService: UserService
    let userRepository: UserRepository
    
    init(
        userService: UserService = MockUserService(),
        userRepository: UserRepository = MockUserRepository()
    ){
        self.userService = userService
        self.userRepository = userRepository
    }
    
    static let preview = Dependency()
    
    class Repositories{
        let dependency: Dependency
        let userRepository: UserRepository
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.userRepository = self.dependency.userRepository
        }
    }
    
    private func repositories() -> Repositories{
        return Repositories(dependency: self)
    }
    
    class Services{
        let dependency: Dependency
        let userService: UserService
        let repositories: Repositories
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.repositories = self.dependency.repositories()
            self.userService = self.dependency.userService
        }
    }
    
    private func services() -> Services{
        return Services(dependency: self)
    }
    
    class ViewModels{
        let services: Services
        let repositories: Repositories
        init(
            services: Services,
            repositories: Repositories
        ){
            self.services = services
            self.repositories = repositories
        }
    }
    
    private func viewModels() -> ViewModels{
        return ViewModels(
            services: services(),
            repositories: repositories()
        )
    }
    
    class Views{
        let viewModels: ViewModels
        
        init(viewModels: ViewModels){
            self.viewModels = viewModels
        }
    }
    
    func views() -> Views{
        return Views(viewModels: viewModels())
    }
}

class MockUserService: UserService{
    override init(
        userRepository: UserRepository = MockUserRepository(),
        initAuthState: AuthState = AuthState.signedIn
    ){
        super.init(userRepository: userRepository)
    }
}

class MockUserRepository: UserRepository{
    override init(initCurrentUser: User? = User(
        id: "something",
        email: "preview email",
        name: "preview name",
        role: .child)
    ){
        super.init(initCurrentUser: initCurrentUser)
    }
    
    override func readCurrentUser(currentUserId: String?) {
        return
    }
    
    override func createUser(newUser: User) {
        return
    }
    
    override func readOtherUser(otherUserId: String) {
        return
    }
}



