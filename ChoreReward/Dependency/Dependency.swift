//
//  Dependency.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/28/21.
//

import Foundation
import UIKit

class Dependency {
    let userRepository: UserRepository
    let familyRepository: FamilyRepository
    let choreRepository: ChoreRepository
    let storageRepository: StorageRepository
    let rewardRepository: RewardRepository

    init(
        userRepository: UserRepository = .init(),
        familyRepository: FamilyRepository = .init(),
        choreRepository: ChoreRepository = .init(),
        storageRepository: StorageRepository = .init(),
        rewardRepository: RewardRepository = .init()
    ) {
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.choreRepository = choreRepository
        self.storageRepository = storageRepository
        self.rewardRepository = rewardRepository
    }

    static let preview = Dependency(
        userRepository: MockUserRepository(),
        familyRepository: MockFamilyRepository(),
        choreRepository: MockChoreRepository(),
        storageRepository: MockStorageRepository(),
        rewardRepository: MockRewardRepository()
    )

    class Repositories {
        let userRepository: UserRepository
        let familyRepository: FamilyRepository
        let choreRepository: ChoreRepository
        let storageRepository: StorageRepository
        let rewardRepository: RewardRepository

        init(dependency: Dependency) {
            self.userRepository = dependency.userRepository
            self.familyRepository = dependency.familyRepository
            self.choreRepository = dependency.choreRepository
            self.storageRepository = dependency.storageRepository
            self.rewardRepository = dependency.rewardRepository
        }
    }

    private func repositories() -> Repositories {
        return Repositories(dependency: self)
    }

    class Services {
        let userService: UserService
        let familyService: FamilyService
        let choreService: ChoreService
        let rewardService: RewardService
        let repositories: Repositories

        init(repositories: Repositories) {
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

            self.rewardService = RewardService(
                userRepository: repositories.userRepository,
                rewardRepository: repositories.rewardRepository
            )
        }
    }

    private func services() -> Services {
        return Services(repositories: repositories())
    }

    class ViewModels {
        let services: Services

        init(
            services: Services
        ) {
            self.services = services
        }
    }

    private func viewModels() -> ViewModels {
        return ViewModels(
            services: services()
        )
    }

    class Views {
        let viewModels: ViewModels

        init(viewModels: ViewModels) {
            self.viewModels = viewModels
        }
    }

    func views() -> Views {
        return Views(viewModels: viewModels())
    }
}

class MockUserRepository: UserRepository {}

class MockFamilyRepository: FamilyRepository {}

class MockChoreRepository: ChoreRepository {}

class MockStorageRepository: StorageRepository {}

class MockRewardRepository: RewardRepository {}
