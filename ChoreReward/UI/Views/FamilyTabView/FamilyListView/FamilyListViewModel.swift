//
//  FamilyListViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import Foundation
import Combine

class FamilyListViewModel: StatefulViewModel{
    @Published var _state: FamilyListState
    static let empty = FamilyListState(
        members: [],
        shouldRenderAddMemberButton: false
    )
    var state: AnyPublisher<FamilyListState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    private let familyService: FamilyService
    private let userService: UserService
    private var familyMemberSubscription: AnyCancellable?
    private var currentUserSubscription: AnyCancellable?
    
    init(
        familyService: FamilyService,
        userService: UserService
    ){
        self.familyService = familyService
        self.userService = userService
        self._state = .init(
            members: [],
            shouldRenderAddMemberButton: false
        )
        addSubscription()
    }
    
    func addSubscription(){
        familyMemberSubscription = familyService.$currentFamily
            .sink(receiveValue: { [weak self] receivedFamily in
                guard let oldState = self?._state, let currentFamily = receivedFamily else{
                    return
                }
                self?._state = .init(
                    members: currentFamily.members,
                    shouldRenderAddMemberButton: oldState.shouldRenderAddMemberButton
                )
            })
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                guard let oldState = self?._state else{
                    return
                }
                self?._state = .init(
                    members: oldState.members,
                    shouldRenderAddMemberButton: receivedUser?.role == .admin
                )
            })
    }
    
    func performAction(_ action: Void) {}
}

struct FamilyListState{
    let members: [DenormUser]
    let shouldRenderAddMemberButton: Bool
}

extension Dependency.ViewModels{
    var familyListViewModel: FamilyListViewModel{
        FamilyListViewModel(
            familyService: services.familyService,
            userService: services.userService
        )
    }
}
