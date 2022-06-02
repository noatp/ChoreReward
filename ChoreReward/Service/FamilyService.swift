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
                if let currentUser = receivedUser {
                    print("\(#fileID) \(#function): received a non-nil user, checking for familyId")
                    guard let currentFamilyId = currentUser.familyId else {
                        print("\(#fileID) \(#function): currentUser does not have a familyId")
                        return
                    }
                    self?.readCurrentFamily(currentFamilyId: currentFamilyId)
                }
                else{
                    print("\(#fileID) \(#function): received a nil user, reset family service")
                    self?.resetService()
                    return
                }
            })
    }

    func createFamily(currentUserId: String) async {
        await familyRepository.createFamily(currentUserId: currentUserId)
    }

    func readCurrentFamily(currentFamilyId: String) {
        currentFamilySubscription = familyRepository.readFamily(familyId: currentFamilyId)
            .sink(receiveValue: { [weak self] receivedFamily in
                self?.currentFamily = receivedFamily
                print("\(#fileID) \(#function): received and cached a non-nil family")
            })
    }

    func addUserToCurrentFamily(userId: String) async {
        guard let currentFamilyId = currentFamily?.id, userId != "" else {
            return
        }
        await familyRepository.updateMembersOfFamily(familyId: currentFamilyId, userId: userId)
    }

    private func resetService() {
        currentFamilySubscription?.cancel()
        currentFamilySubscription = nil
        currentFamily = nil
        familyRepository.resetRepository()
    }
}
