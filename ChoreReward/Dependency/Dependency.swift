//
//  Dependency.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/28/21.
//

import Foundation
import UIKit

class Dependency{
    let userRepository: UserRepository
    let familyRepository: FamilyRepository
    let choreRepository: ChoreRepository
    let storageRepository: StorageRepository
    
    init(
        userRepository: UserRepository = UserRepository(userDatabase: UserDatabase()),
        familyRepository: FamilyRepository = FamilyRepository(),
        choreRepository: ChoreRepository = ChoreRepository(),
        storageRepository: StorageRepository = StorageRepository()
    ){
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.choreRepository = choreRepository
        self.storageRepository = storageRepository
    }
    
    static let preview = Dependency(
        userRepository: MockUserRepository(userDatabase: MockUserDatabase()),
        familyRepository: MockFamilyRepository(),
        choreRepository: MockChoreRepository(),
        storageRepository: MockStorageRepository()
    )
    
    class Repositories{
        let userRepository: UserRepository
        let familyRepository: FamilyRepository
        let choreRepository: ChoreRepository
        let storageRepository: StorageRepository
        
        init(dependency: Dependency){
            self.userRepository = dependency.userRepository
            self.familyRepository = dependency.familyRepository
            self.choreRepository = dependency.choreRepository
            self.storageRepository = dependency.storageRepository
            
        }
    }
    
    private func repositories() -> Repositories{
        return Repositories(dependency: self)
    }
    
    class Services{
        let userService: UserService
        let familyService: FamilyService
        let choreService: ChoreService
        let repositories: Repositories
        
        init(repositories: Repositories){
            self.repositories = repositories
            self.userService = UserService(
                currentUserRepository: repositories.userRepository,
                storageRepository: repositories.storageRepository
            )
            self.familyService = FamilyService(
                userRepository: repositories.userRepository,
                familyRepository: repositories.familyRepository
            )
            self.choreService = ChoreService(
                userRepository: repositories.userRepository,
                familyRepository: repositories.familyRepository,
                choreRepository: repositories.choreRepository,
                storageRepository: repositories.storageRepository)
        }
    }
    
    private func services() -> Services{
        return Services(repositories: repositories())
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


