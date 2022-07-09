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
    var viewState: AnyPublisher<UserProfileState, Never> {
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
                    currentUserProfileImageUrl: receivedUser?.userImageUrl
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
