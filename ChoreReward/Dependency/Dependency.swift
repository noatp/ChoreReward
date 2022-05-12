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
    let storageRepository: StorageRepository
        
    init(
        userService: UserService = MockUserService(),
        familyService: FamilyService = MockFamilyService(),
        choreService: ChoreService = MockChoreService(),
        currentUserRepository: UserRepository = MockUserRepository(),
        currentFamilyRepository: FamilyRepository = MockFamilyRepository(),
        currentChoreRepository: ChoreRepository = MockChoreRepository(),
        storageRepository: StorageRepository = StorageRepository()
    ){
        self.userService = userService
        self.familyService = familyService
        self.choreService = choreService
        self.currentUserRepository = currentUserRepository
        self.currentFamilyRepository = currentFamilyRepository
        self.currentChoreRepository = currentChoreRepository
        self.storageRepository = storageRepository
    }
    
    static let preview = Dependency()
    
    class Repositories{
        let dependency: Dependency
        let userRepository: UserRepository
        let familyRepository: FamilyRepository
        let choreRepository: ChoreRepository
        let storageRepository: StorageRepository
        
        init(dependency: Dependency){
            self.dependency = dependency
            self.userRepository = self.dependency.currentUserRepository
            self.familyRepository = self.dependency.currentFamilyRepository
            self.choreRepository = self.dependency.currentChoreRepository
            self.storageRepository = self.dependency.storageRepository
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

class MockStorageRepository: StorageRepository{}

class MockUserService: UserService{
    override init(
        currentUserRepository: UserRepository = MockUserRepository(),
        storageRepository: StorageRepository = StorageRepository()
    ){
        super.init(
            currentUserRepository: currentUserRepository,
            storageRepository: storageRepository
        )
    }
}

class MockFamilyService: FamilyService{
    override init(
        userRepository currentUserRepository: UserRepository = MockUserRepository(),
        familyRepository currentFamilyRepository: FamilyRepository = MockFamilyRepository()
    ) {
        super.init(
            userRepository: currentUserRepository,
            familyRepository: currentFamilyRepository
        )
    }
}

class MockChoreService: ChoreService{
    override init(
        userRepository: UserRepository = MockUserRepository(),
        familyRepository: FamilyRepository = MockFamilyRepository(),
        choreRepository: ChoreRepository = MockChoreRepository(),
        storageRepository: StorageRepository = MockStorageRepository()
    ){
        super.init(
            userRepository: userRepository,
            familyRepository: familyRepository,
            choreRepository: choreRepository,
            storageRepository: storageRepository
        )
    }
}



