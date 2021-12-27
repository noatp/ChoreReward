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
    let currentUserRepository: UserRepository
    let currentFamilyRepository: FamilyRepository
    let familyService: FamilyService
    
    init(
        userService: UserService = MockUserService(),
        currentUserRepository: UserRepository = MockUserRepository(),
        currentFamilyRepository: FamilyRepository = MockFamilyRepository(),
        familyService: FamilyService = MockFamilyService()
    ){
        self.userService = userService
        self.currentUserRepository = currentUserRepository
        self.currentFamilyRepository = currentFamilyRepository
        self.familyService = familyService
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
        currentUserRepository: UserRepository = MockUserRepository(),
        initAuthState: AuthState = AuthState.signedIn
    ){
        super.init(
            currentUserRepository: currentUserRepository
        )
    }
}

class MockUserRepository: UserRepository{
    override init(
        initUser: User? = User.previewBen,
        initUsers: [User] = [User.previewTim, User.previewDavid]
    ) {
        super.init(
            initUser: initUser,
            initUsers: initUsers
        )
    }
    
    override func readUser(userId: String?) {
        return
    }
    
    override func createUser(newUser: User) {
        return
    }
}

class MockFamilyRepository: FamilyRepository{
    override init(
        initFamily: Family? = Family.preview
    ) {
        super.init(
            initFamily: initFamily
        )
    }
    
    override func createFamily(currentUserId: String, newFamilyId: String) {
        return
    }
    
    override func readFamily(familyId: String) {
        return
    }
    
    override func updateMemberOfFamily(familyId: String, userId: String) {
        return
    }
}

class MockFamilyService: FamilyService{
    override init(
        currentUserRepository: UserRepository = MockUserRepository(),
        currentFamilyRepository: FamilyRepository = MockFamilyRepository(),
        initCurrentFamily: Family? = nil
    ) {
        super.init(
            currentUserRepository: currentUserRepository,
            currentFamilyRepository: currentFamilyRepository,
            initCurrentFamily: initCurrentFamily
        )
    }
}



