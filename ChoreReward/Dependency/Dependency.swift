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
    let familyService: FamilyService
    let choreService: ChoreService
    
    let currentUserRepository: UserRepository
    let currentFamilyRepository: FamilyRepository
    let currentChoreRepository: ChoreRepository
    
    init(
        userService: UserService = MockUserService(),
        familyService: FamilyService = MockFamilyService(),
        choreService: ChoreService = MockChoreService(),
        currentUserRepository: UserRepository = MockUserRepository(),
        currentFamilyRepository: FamilyRepository = MockFamilyRepository(),
        currentChoreRepository: ChoreRepository = MockChoreRepository()
    ){
        self.userService = userService
        self.familyService = familyService
        self.choreService = choreService
        self.currentUserRepository = currentUserRepository
        self.currentFamilyRepository = currentFamilyRepository
        self.currentChoreRepository = currentChoreRepository
    }
    
    static let preview = Dependency()
    
    class Repositories{
        let dependency: Dependency
        let userRepository: UserRepository
        let familyRepository: FamilyRepository
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.userRepository = self.dependency.currentUserRepository
            self.familyRepository = self.dependency.currentFamilyRepository
        }
    }
    
    private func repositories() -> Repositories{
        return Repositories(dependency: self)
    }
    
    class Services{
        let dependency: Dependency
        let userService: UserService
        let familyService: FamilyService
        let choreService: ChoreService
        let repositories: Repositories
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.repositories = self.dependency.repositories()
            self.userService = self.dependency.userService
            self.familyService = self.dependency.familyService
            self.choreService = self.dependency.choreService
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

class MockUserRepository: UserRepository{}

class MockFamilyRepository: FamilyRepository{}

class MockChoreRepository: ChoreRepository{}

class MockUserService: UserService{
    override init(
        currentUserRepository: UserRepository = MockUserRepository()
    ){
        super.init(
            currentUserRepository: currentUserRepository
        )
    }
}

class MockFamilyService: FamilyService{
    override init(
        currentUserRepository: UserRepository = MockUserRepository(),
        currentFamilyRepository: FamilyRepository = MockFamilyRepository()
    ) {
        super.init(
            currentUserRepository: currentUserRepository,
            currentFamilyRepository: currentFamilyRepository
        )
    }
}

class MockChoreService: ChoreService{
    override init(
        currentUserRepository: UserRepository = MockUserRepository(),
        currentFamilyRepository: FamilyRepository = MockFamilyRepository(),
        currentChoreRepository: ChoreRepository = MockChoreRepository()
    ){
        super.init(
            currentUserRepository: currentUserRepository,
            currentFamilyRepository: currentFamilyRepository,
            currentChoreRepository: currentChoreRepository
        )
    }
}



