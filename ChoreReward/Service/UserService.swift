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

class UserService: ObservableObject {
    @Published var authState: AuthState?
    @Published var currentUser: User?

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
        if UserDefaults.standard.value(forKey: "appFirstRun") == nil {
            UserDefaults.standard.setValue(true, forKey: "appFirstRun")
            self.signOut()
        }
    }

    private func checkCurentAuthSession(afterAuthenticated: (_ currentUserId: String) -> Void) {
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): no authorized user session -> doing nothing")
            authState = .signedOut(error: nil)
            return
        }
        print("\(#fileID) \(#function): has authorized user session -> fetching new user data")
        afterAuthenticated(currentUserId)
    }

    func silentSignIn() {
        checkCurentAuthSession { currentUserId in
            self.authState = .signedIn
            readCurrentUser(currentUserId: currentUserId)
        }
    }

    func signIn(email: String, password: String) async {
        do {
            try await auth.signIn(withEmail: email, password: password)
            checkCurentAuthSession { currentUserId in
                self.authState = .signedIn
                readCurrentUser(currentUserId: currentUserId)
            }
        } catch {
            print("\(#fileID) \(#function): \(error)")
            authState = .signedOut(error: error)
        }
    }

    func signUp(newUser: User, password: String, userImageUrl: String?) async {
        do {
            try await auth.createUser(withEmail: newUser.email, password: password)
            checkCurentAuthSession { currentUserId in
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

                self.authState = .signedIn
                readCurrentUser(currentUserId: currentUserId)
            }
        } catch {
            print("\(#fileID) \(#function): \(error)")
            authState = .signedOut(error: error)
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
        guard let currentUserId = currentUserId else {
            print("\(#fileID) \(#function): could not retrieve currentUserId")
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
            })
    }

    private func reset() {
        print("\(#fileID) \(#function): reseting user service")
        currentUser = nil
        authState = .signedOut(error: nil)
        userRepository.resetRepository()
    }

    enum AuthState {
        case signedIn
        case signedOut(error: Error?)
    }
}
