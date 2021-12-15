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
    let familyRepository: FamilyRepository
    let familyService: FamilyService
    
    init(
        userService: UserService = MockUserService(),
        userRepository: UserRepository = MockUserRepository(),
        familyRepository: FamilyRepository = MockFamilyRepository(),
        familyService: FamilyService = MockFamilyService()
    ){
        self.userService = userService
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.familyService = familyService
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
        let userService: UserService
        let familyService: FamilyService
        let repositories: Repositories
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.repositories = self.dependency.repositories()
            self.userService = self.dependency.userService
            self.familyService = self.dependency.familyService
        }
    }
    
    private func services() -> Services{
        return Services(dependency: self)
    }
    
    class ViewModels{
        let services: Services
        init(
            services: Services
        ){
            self.services = services
        }
    }
    
    private func viewModels() -> ViewModels{
        return ViewModels(
            services: services()
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
        familyRepository: FamilyRepository = MockFamilyRepository(),
        initAuthState: AuthState = AuthState.signedIn
    ){
        super.init(
            userRepository: userRepository,
            familyRepository: familyRepository
        )
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

class MockFamilyRepository: FamilyRepository{
    
}

class MockFamilyService: FamilyService{
    override init(
        userRepository: UserRepository = MockUserRepository(),
        familyRepository: FamilyRepository = MockFamilyRepository(),
        initCurrentFamily: Family? = nil
    ) {
        super.init(
            userRepository: userRepository,
            familyRepository: familyRepository,
            initCurrentFamily: initCurrentFamily
        )
    }
}



