//
//  FamilyListViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import Foundation
import Combine

class FamilyTabViewModel: StatefulViewModel {
    @Published var _state: FamilyTabState?
    var viewState: AnyPublisher<FamilyTabState?, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let familyService: FamilyService
    private let userService: UserService
    private var familyMemberSubscription: AnyCancellable?
    private var currentUserSubscription: AnyCancellable?

    init(
        familyService: FamilyService,
        userService: UserService
    ) {
        self.familyService = familyService
        self.userService = userService
        addSubscription()
    }

    func addSubscription() {
        familyMemberSubscription = familyService.$currentFamily
            .sink(receiveValue: { [weak self] receivedFamily in
                guard let receivedFamily = receivedFamily else {
                    return
                }
                if let oldState = self?._state {
                    self?._state = .init(
                        members: receivedFamily.members,
                        shouldRenderAddMemberButton: oldState.shouldRenderAddMemberButton
                    )
                } else {
                    self?._state = .init(
                        members: receivedFamily.members,
                        shouldRenderAddMemberButton: false
                    )
                }
            })
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                guard let receivedUser = receivedUser else {
                    return
                }
                if let oldState = self?._state {
                    self?._state = .init(
                        members: oldState.members,
                        shouldRenderAddMemberButton: receivedUser.role == .admin
                    )
                } else {
                    self?._state = .init(
                        members: [],
                        shouldRenderAddMemberButton: receivedUser.role == .admin
                    )
                }
            })
    }

    func performAction(_ action: Void) {}
}

struct FamilyTabState {
    let members: [DenormUser]
    let shouldRenderAddMemberButton: Bool
    static let preview: FamilyTabState = .init(members: [.preview], shouldRenderAddMemberButton: true)
}

extension Dependency.ViewModels {
    var familyTabViewModel: FamilyTabViewModel {
        FamilyTabViewModel(
            familyService: services.familyService,
            userService: services.userService
        )
    }
}
