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
    static var empty: ChoreTabState = .init(shouldRenderAddChoreButton: false)
    var state: AnyPublisher<ChoreTabState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    private let userService: UserService
    private let choreService: ChoreService
    
    init(
        userService: UserService,
        choreService: ChoreService
    ) {
        self.userService = userService
        self.choreService = choreService
        self._state = .init(shouldRenderAddChoreButton: userService.isCurrentUserParent())
    }
    
    

    func performAction(_ action: ChoreTabAction) {
        switch action {
        case .createChore(let choreTitle):
            choreService.createChore(choreTitle: choreTitle)
        }
    }
}

struct ChoreTabState{
    let shouldRenderAddChoreButton: Bool
}

enum ChoreTabAction{
    case createChore(choreTitle: String)
}

extension Dependency.ViewModels{
    var choreTabViewModel: ChoreTabViewModel{
        ChoreTabViewModel(
            userService: services.userService,
            choreService: services.choreService
        )
    }
}
