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
    
    init(userService: UserService) {
        self.userService = userService
        self._state = .init(shouldRenderAddChoreButton: userService.isCurrentUserParent())
    }
    
    

    func performAction(_ action: ChoreTabAction) {}
}

struct ChoreTabState{
    let shouldRenderAddChoreButton: Bool
}

enum ChoreTabAction{}

extension Dependency.ViewModels{
    var choreTabViewModel: ChoreTabViewModel{
        ChoreTabViewModel(userService: services.userService)
    }
}
