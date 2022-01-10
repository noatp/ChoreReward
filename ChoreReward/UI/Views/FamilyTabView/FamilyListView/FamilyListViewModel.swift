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
            shouldRenderAddMemberButton: familyService.isCurrentUserAdminOfCurrentFamily()
        )
        addSubscription()
    }
    
    func addSubscription(){
        familyMemberSubscription = familyService.$currentFamilyMembers
            .sink(receiveValue: { [weak self] receivedFamilyMembers in
                guard let oldState = self?._state else{
                    return
                }
                self?._state = .init(
                    members: receivedFamilyMembers,
                    shouldRenderAddMemberButton: oldState.shouldRenderAddMemberButton
                )
            })
    }
    
    func performAction(_ action: Void) {}
}

struct FamilyListState{
    let members: [User]
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
