//
//  ChoreTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

class ChoreTabViewModel: StatefulViewModel{
    @Published var _state: ChoreTabState = empty
    static var empty: ChoreTabState = .init(shouldRenderAddChoreButton: false, choreList: [])
    var state: AnyPublisher<ChoreTabState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    private let userService: UserService
    private let choreService: ChoreService
    private var choreListSubscription: AnyCancellable?
    private var currentUserSubscription: AnyCancellable?
    
    init(
        userService: UserService,
        choreService: ChoreService
    ) {
        self.userService = userService
        self.choreService = choreService
        self._state = .init(
            shouldRenderAddChoreButton: false,
            choreList: []
        )
        addSubscription()
        print("new choretabviewmodel here")
    }
    
    func addSubscription(){
        choreListSubscription = choreService.$choreList
            .sink(receiveValue: { [weak self] receivedChoreList in
                guard let oldState = self?._state else{
                    return
                }
                self?._state = .init(
                    shouldRenderAddChoreButton: oldState.shouldRenderAddChoreButton,
                    choreList: receivedChoreList
                )
            })
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                guard let oldState = self?._state else{
                    return
                }
                self?._state = .init(
                    shouldRenderAddChoreButton: self?.userService.isCurrentUserParent() ?? false,
                    choreList: oldState.choreList
                )
                
            })
    }
    
    func performAction(_ action: ChoreTabAction) {
    }
}

struct ChoreTabState{
    let shouldRenderAddChoreButton: Bool
    let choreList: [Chore]
}

enum ChoreTabAction{
}

extension Dependency.ViewModels{
    var choreTabViewModel: ChoreTabViewModel{
        ChoreTabViewModel(
            userService: services.userService,
            choreService: services.choreService
        )
    }
}
