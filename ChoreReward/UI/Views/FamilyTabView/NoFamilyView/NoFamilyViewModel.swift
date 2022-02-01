//
//  NoFamilyViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/26/21.
//

import Foundation
import Combine

class NoFamilyViewModel: StatefulViewModel{
    @Published var _state: NoFamilyState = empty
    static let empty = NoFamilyState(
        shouldRenderCreateFamilyButton: false,
        currentUserId: ""
    )
    
    private let userService: UserService
    private let familyService: FamilyService
    private var currentUserSubscription: AnyCancellable?
    
    var state: AnyPublisher<NoFamilyState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    init(
        userService: UserService,
        familyService: FamilyService
    ){
        self.userService = userService
        self.familyService = familyService
        addSubscription()
    }
    
    func addSubscription(){
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                self?._state = .init(
                    shouldRenderCreateFamilyButton: receivedUser?.role == .parent,
                    currentUserId: receivedUser?.id ?? ""
                )
            })
    }
    
    func createFamily(){
        guard let currentUser = userService.currentUser else{
            return
        }
        Task{
            await familyService.createFamily(currentUser: currentUser)
        }
    }
    
    func performAction(_ action: NoFamilyAction) {
        switch(action){
        case .createFamily:
            createFamily()
        }
    }
}

struct NoFamilyState{
    let shouldRenderCreateFamilyButton: Bool
    let currentUserId: String
}

enum NoFamilyAction{
    case createFamily
}

extension Dependency.ViewModels{
    var noFamilyViewModel: NoFamilyViewModel{
        NoFamilyViewModel(
            userService: services.userService,
            familyService: services.familyService
        )
    }
}
