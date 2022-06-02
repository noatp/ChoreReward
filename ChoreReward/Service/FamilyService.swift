//
//  FamilyService.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/13/21.
//

import Foundation
import Combine

class FamilyService: ObservableObject {
    @Published var currentFamily: Family?

    private let userRepository: UserRepository
    private let familyRepository: FamilyRepository

    private var currentUserSubscription: AnyCancellable?
    private var currentFamilySubscription: AnyCancellable?

    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository
    ) {
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        addSubscription()
    }

    func addSubscription() {
        currentUserSubscription = userRepository.readUser()
            .sink(receiveValue: { [weak self] receivedUser in
                guard let currentUser = receivedUser else {
                    // logged out
                    self?.resetService()
                    return
                }
                print("\(#fileID) \(#function): received new user from UserDatabase through UserRepository")
                self?.readCurrentFamily(currentUser: currentUser)
            })
    }

    func createFamily(currentUser: User) async {
        await familyRepository.createFamily(currentUser: currentUser)
    }

    func readCurrentFamily(currentUser: User) {
        guard let currentFamilyId = currentUser.familyId else {
            print("\(#fileID) \(#function): currentUser does not have a family")
            return
        }
        currentFamilySubscription = familyRepository.readFamily(familyId: currentFamilyId)
            .sink(receiveValue: { [weak self] receivedFamily in
                print("\(#fileID) \(#function): received new family from FamilyDatabse through FamilyRepository")
                self?.currentFamily = receivedFamily
            })
    }

    func addUserToCurrentFamily(userId: String) async {
        guard let currentFamilyId = currentFamily?.id else {
            return
        }
        guard userId != "" else {
            return
        }
        await familyRepository.updateMembersOfFamily(familyId: currentFamilyId, userId: userId)

//        await userRepository.updateFamilyForUser(familyId: currentFamilyId, userId: userId)
    }

    private func resetService() {
        currentFamilySubscription?.cancel()
        currentFamilySubscription = nil
        currentFamily = nil
        familyRepository.resetRepository()
    }
}
