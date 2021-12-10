//
//  Dependency.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/28/21.
//

import Foundation
import UIKit

class Dependency{
    let authService: AuthService
    let userRepository: UserRepository
    let familyRepository: FamilyRepository
    
    init(
        authService: AuthService = MockAuthService(),
        userRepository: UserRepository = MockUserRepository(),
        familyRepository: FamilyRepository = MockFamilyRepository()
    ){
        self.authService = authService
        self.userRepository = userRepository
        self.familyRepository = familyRepository
    }
    
    static let preview = Dependency()
    
    class Repositories{
        let dependency: Dependency
        let userRepository: UserRepository
        let familyRepository: FamilyRepository
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.userRepository = self.dependency.userRepository
            self.familyRepository = self.dependency.familyRepository
        }
    }
    
    private func repositories() -> Repositories{
        return Repositories(dependency: self)
    }
    
    class Services{
        let dependency: Dependency
        let authService: AuthService
        let repositories: Repositories
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.repositories = self.dependency.repositories()
            self.authService = self.dependency.authService
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

class MockAuthService: AuthService{
    override init(
        userRepository: UserRepository = MockUserRepository(),
        initAuthState: AuthState = AuthState.signedIn
    ){
        super.init(userRepository: userRepository)
    }
}

class MockUserRepository: UserRepository{
    override init(initUser: User? = User(
        id: "something",
        email: "preview email",
        name: "preview name",
        role: .child)
    ){
        super.init(initUser: initUser)
    }
    
    override func readUser(userId: String) {
        return
    }
    
    override func createUser(newUser: User) {
        return
    }
}

class MockFamilyRepository: FamilyRepository{
    
}



