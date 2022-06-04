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
    // private var isLoginPending: Bool = false

    var currentUserId: String? {
        auth.currentUser?.uid
    }

    init(
        currentUserRepository: UserRepository,
        storageRepository: StorageRepository
    ) {
        self.userRepository = currentUserRepository
        self.storageRepository = storageRepository
    }

    private func performSignIn() {
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): currentUserId is nil")
            return
        }
        currentUserSubscription = userRepository.readUser(userId: currentUserId)
            .sink(receiveValue: {[weak self] receivedUser in
                print("\(#fileID) \(#function): received a user")
                self?.currentUser = receivedUser
                self?.authState = .signedIn
                self?.isBusy = false
            })
    }

    func silentSignIn() async {
        performSignIn()
    }

    func signIn(email: String, password: String) async {
        do {
            isBusy = true
            try await auth.signIn(withEmail: email, password: password)
            performSignIn()
        } catch {
            print("\(#fileID) \(#function): \(error)")
            authState = .signedOut(error: error)
            isBusy = false
        }
    }

    func signUp(newUser: User, password: String, profileImage: UIImage?) async {
        do {
            isBusy = true
            try await auth.createUser(withEmail: newUser.email, password: password)
            guard let currentUserId = currentUserId else {
                return
            }

            let user = User(
                id: currentUserId,
                email: newUser.email,
                name: newUser.name,
                role: newUser.role,
                profileImageUrl: nil
            )
            await userRepository.createUser(newUser: user)

            if let profileImage = profileImage {
                changeUserProfileImage(image: profileImage)
            }

            performSignIn()
        } catch {
            print("\(#fileID) \(#function): \(error)")
            authState = .signedOut(error: error)
            isBusy = false
        }
    }

    func signOut() {
        do {
            try self.auth.signOut()
            resetService()
        } catch let signOutError as NSError {
            print("\(#fileID) \(#function): Error signing out: %@", signOutError)
        }
    }

    func changeUserProfileImage(image: UIImage) {
        isBusy = true
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): could not retrieve currentUserId")
            return
        }

        Task {
            let profileImageUrl = await storageRepository.uploadUserProfileImage(image: image, userId: currentUserId)

            guard let profileImageUrl = profileImageUrl else {
                print("\(#fileID) \(#function): could not get a url for the profile image")
                return
            }

            await userRepository.updateProfileImageForUser(userId: currentUserId, profileImageUrl: profileImageUrl)
            isBusy = false
        }
    }

    func updateUserProfileWithImage(newUserProfile: User, newUserImage: UIImage?) {
        isBusy = true
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): could not retrieve currentUserId")
            isBusy = false
            return
        }

        if let newUserImage = newUserImage {
            Task {
                let profileImageUrl =  await storageRepository.uploadUserProfileImage(image: newUserImage, userId: currentUserId)

                guard let profileImageUrl = profileImageUrl else {
                    print("\(#fileID) \(#function): could not get a url for the profile image")
                    return
                }

                let userProfileWithImage = User(
                    email: newUserProfile.email,
                    name: newUserProfile.name,
                    role: newUserProfile.role,
                    profileImageUrl: profileImageUrl
                )

                print("\(#fileID) \(#function): calling userRepository with image link")
                await userRepository.updateUserProfileWithImage(userId: currentUserId, newUserProfileWithImage: userProfileWithImage)
                isBusy = false
            }

        } else {
            let newUserProfileWithImage = User(
                email: newUserProfile.email,
                name: newUserProfile.name,
                role: newUserProfile.role,
                profileImageUrl: nil
            )
            Task {
                print("\(#fileID) \(#function): calling userRepository with nil image link")
                await userRepository.updateUserProfileWithImage(userId: currentUserId, newUserProfileWithImage: newUserProfileWithImage)
                isBusy = false
            }
        }
    }

    func updateUserProfileWithoutImage(newUserProfile: User) {
        isBusy = true
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): could not retrieve currentUserId")
            isBusy = false
            return
        }

        let newUserProfileWithoutImage = User(
            email: newUserProfile.email,
            name: newUserProfile.name,
            role: newUserProfile.role
        )
        Task {
            print("\(#fileID) \(#function): calling userRepository without image link")
            await userRepository.updateUserProfileWithoutImage(userId: currentUserId, newUserProfileWithoutImage: newUserProfileWithoutImage)
            isBusy = false
        }
    }

    private func resetService() {
        currentUser = nil
        authState = .signedOut(error: nil)
        currentUserSubscription = nil
        userRepository.resetRepository()
    }

    enum AuthState {
        case signedIn
        case signedOut(error: Error?)
    }
}
