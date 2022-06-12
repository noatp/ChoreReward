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
    private var currentFamilyId: String?

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
        currentUserSubscription = userRepository.userPublisher
            .sink(receiveValue: { [weak self] receivedUser in
                if let receivedUser = receivedUser {
                    print("\(#fileID) \(#function): received a non-nil user, checking for familyId")
                    guard let receivedFamilyId = receivedUser.familyId else {
                        print("\(#fileID) \(#function): received user does not have a familyId")
                        self?.currentFamily = nil
                        return
                    }
                    // case familyId of user got changed, check if same familyId
                    // if not, reset service to listen to new family
                    if let currentFamilyIdInCache = self?.currentFamilyId, receivedFamilyId == currentFamilyIdInCache {
                        print("\(#fileID) \(#function): received user has same familyId as the cached family -> doing nothing")
                        return
                    } else {
                        print("\(#fileID) \(#function): received-user has diff familyId from the cached family -> resetting family service & fetch new family data")
                        self?.resetService()
                        self?.currentFamilyId = receivedFamilyId
                        self?.readCurrentFamily(currentFamilyId: receivedFamilyId)
                        return
                    }
                } else {
                    print("\(#fileID) \(#function): received reset signal from UserRepository, reset family service")
                    self?.resetService()
                    return
                }
            })
        currentFamilySubscription = familyRepository.familyPublisher
            .sink(receiveValue: { [weak self] receivedFamily in
                guard let currentFamily = receivedFamily else {
                    return
                }
                self?.currentFamily = currentFamily
                print("\(#fileID) \(#function): received and cached a non-nil family")
            })
    }

    func createFamily(currentUserId: String) async {
        await familyRepository.createFamily(currentUserId: currentUserId)
    }

    func readCurrentFamily(currentFamilyId: String) {
        familyRepository.readFamily(familyId: currentFamilyId)
    }

    func addUserToCurrentFamily(userId: String) async {
        guard let currentFamilyId = currentFamily?.id, userId != "" else {
            return
        }
        await familyRepository.updateMembersOfFamily(familyId: currentFamilyId, userId: userId)
    }

    private func resetService() {
        currentFamily = nil
        currentFamilyId = nil
        familyRepository.resetRepository()
    }
}
