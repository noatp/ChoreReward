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
    @Published var _state: UserProfileState?
    var viewState: AnyPublisher<UserProfileState?, Never> {
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
                guard let receivedUser = receivedUser else {
                    return
                }
                self?._state = .init(
                    currentUserEmail: receivedUser.email,
                    currentUserName: receivedUser.name,
                    currentUserRole: receivedUser.role.rawValue,
                    currentUserProfileImageUrl: receivedUser.userImageUrl
                )
            })
    }

    private func signOut() {
        userService.signOut()
    }

    func performAction(_ action: UserProfileAction) {
        switch action {
        case .signOut:
            signOut()
        }
    }
}

struct UserProfileState {
    let currentUserEmail: String
    let currentUserName: String
    let currentUserRole: String
    let currentUserProfileImageUrl: String?
    static let preview: UserProfileState = .init(
        currentUserEmail: "toan.chpham@gmail.com",
        currentUserName: "Toan Pham",
        currentUserRole: "Admin",
        currentUserProfileImageUrl: "https://www.apple.com/leadership/"
        + "images/bio/tim-cook_image.png.og.png?1656498323724"
    )
}

enum UserProfileAction {
    case signOut
}

extension Dependency.ViewModels {
    var userProfileViewModel: UserProfileViewModel {
        UserProfileViewModel(
            userService: services.userService
        )
    }
}
