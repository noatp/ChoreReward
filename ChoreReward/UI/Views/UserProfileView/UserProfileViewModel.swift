//
//  UserTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import SwiftUI
import Combine

class UserProfileViewModel: StatefulViewModel {
    @Published var _state: UserProfileState = empty
    static let empty = UserProfileState(
        currentUserEmail: "",
        currentUserName: "",
        currentUserRole: "",
        currentUserProfileImageUrl: nil
    )
    var state: AnyPublisher<UserProfileState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private var currentUserSubscription: AnyCancellable?

    init(
        userService: UserService
    ) {
        self.userService = userService
        self.addSubscription()
    }

    func addSubscription() {
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                self?._state = .init(
                    currentUserEmail: receivedUser?.email ?? "",
                    currentUserName: receivedUser?.name ?? "",
                    currentUserRole: receivedUser?.role.rawValue ?? "",
                    currentUserProfileImageUrl: receivedUser?.profileImageUrl
                )
            })
    }

    private func signOut() {
        userService.signOut()
    }

    private func changeUserProfileImage(image: UIImage) {
        userService.changeUserProfileImage(image: image)
    }

    func performAction(_ action: UserProfileAction) {
        switch action {
        case .signOut:
            signOut()
        case .changeUserProfileImage(let image):
            changeUserProfileImage(image: image)
        }
    }
}

struct UserProfileState {
    let currentUserEmail: String
    let currentUserName: String
    let currentUserRole: String
    let currentUserProfileImageUrl: String?
}

enum UserProfileAction {
    case signOut
    case changeUserProfileImage(image: UIImage)
}

extension Dependency.ViewModels {
    var userProfileViewModel: UserProfileViewModel {
        UserProfileViewModel(
            userService: services.userService
        )
    }
}
