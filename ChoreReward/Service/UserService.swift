//
//  AuthenticationService.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import Foundation
import FirebaseAuth
import Combine
import SwiftUI

/*
 NOTE TO SELF:
 - service should try to validate parameter before calling Repository
 
 script to remove all authentication
 setInterval(() => {
     document.getElementsByClassName('edit-account-button mat-focus-indicator mat-menu-trigger mat-icon-button mat-button-base')[0].click()
     let deleteButtonPosition = document.getElementsByClassName('mat-focus-indicator mat-menu-item ng-star-inserted').length - 1
     document.getElementsByClassName('mat-focus-indicator mat-menu-item ng-star-inserted')[deleteButtonPosition].click()
     document.getElementsByClassName('confirm-button mat-focus-indicator mat-raised-button mat-button-base mat-warn')[0].click()
 }, 1000)
 
 
 */

class UserService: ObservableObject {
    @Published var authState: AuthState = .signedOut(error: nil)
    @Published var currentUser: User?
    @Published var isBusy: Bool = false

    private let auth = Auth.auth()
    private let userRepository: UserRepository
    private let storageRepository: StorageRepository

    private var currentUserSubscription: AnyCancellable?

    var currentUserId: String? {
        auth.currentUser?.uid
    }

    init(
        currentUserRepository: UserRepository,
        storageRepository: StorageRepository
    ) {
        self.userRepository = currentUserRepository
        self.storageRepository = storageRepository
        addSubscription()
    }

    func silentSignIn() {
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): no authorized user session")
            self.authState = .signedOut(error: nil)
            return
        }
        print("\(#fileID) \(#function): has authorized user session -> resetting user service & fetching new user data")
        self.reset()
        self.authState = .signedIn
        readCurrentUser(currentUserId: currentUserId)
    }

    func signIn(email: String, password: String) async {
        do {
            isBusy = true
            try await auth.signIn(withEmail: email, password: password)
            guard let currentUserId = currentUserId else {
                print("\(#fileID) \(#function): currentUserId is nil")
                return
            }
            readCurrentUser(currentUserId: currentUserId)
        } catch {
            print("\(#fileID) \(#function): \(error)")
            authState = .signedOut(error: error)
            isBusy = false
        }
    }

    func signUp(newUser: User, password: String, userImageUrl: String?) async {
        do {
            isBusy = true
            try await auth.createUser(withEmail: newUser.email, password: password)
            guard let currentUserId = currentUserId else {
                return
            }

            let newUser = User(
                id: currentUserId,
                email: newUser.email,
                name: newUser.name,
                role: newUser.role,
                userImageUrl: userImageUrl
            )

            userRepository.create(newUser)
            if let userImageUrl = userImageUrl {
                storageRepository.uploadUserImage(with: userImageUrl) { [weak self] newUserImageUrl in
                    self?.updateUserImage(with: newUserImageUrl)
                }
            }

            readCurrentUser(currentUserId: currentUserId)
        } catch {
            print("\(#fileID) \(#function): \(error)")
            authState = .signedOut(error: error)
            isBusy = false
        }
    }

    func signOut() {
        do {
            try self.auth.signOut()
            reset()
        } catch let signOutError as NSError {
            print("\(#fileID) \(#function): Error signing out: %@", signOutError)
        }
    }

    func updateUserProfileForCurrentUser(withNewUserProfile newUserProfile: User,
                                         andNewUserImageUrl newUserImageUrl: String?,
                                         whenUserImageDidChange userImageDidChange: Bool) {
        isBusy = true
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): could not retrieve currentUserId")
            isBusy = false
            return
        }

        var newUser: User = .empty

        if userImageDidChange {
            newUser = User( // with image url
                email: newUserProfile.email,
                name: newUserProfile.name,
                role: newUserProfile.role,
                userImageUrl: newUserImageUrl
            )

            if let newUserImageUrl = newUserImageUrl {
                storageRepository.uploadUserImage(with: newUserImageUrl) { [weak self] uploadedUserImageUrl in
                    self?.updateUserImage(with: uploadedUserImageUrl)
                }
            }
        } else {
            newUser = newUserProfile // without image url
        }

        userRepository.updateProfileForUser(with: currentUserId, using: newUser)

        isBusy = false
    }

    private func updateUserImage(with imageUrl: String) {
        guard let currentUserId = currentUserId  else {
            print("\(#fileID) \(#function): missing userId")
            return
        }
        Task {
            await userRepository.updateUserImage(for: currentUserId, with: imageUrl)
        }
    }

    private func readCurrentUser(currentUserId: String) {
        userRepository.readUser(userId: currentUserId)
    }

    private func addSubscription() {
        currentUserSubscription = userRepository.userPublisher
            .sink(receiveValue: {[weak self] receivedUser in
                guard let currentUser = receivedUser else {
                    return
                }
                self?.currentUser = currentUser
                print("\(#fileID) \(#function): received and cached a non-nil user")
                self?.isBusy = false
            })
    }

    private func reset() {
        currentUser = nil
        authState = .signedOut(error: nil)
        userRepository.resetRepository()
    }

    enum AuthState {
        case signedIn
        case signedOut(error: Error?)
    }
}
