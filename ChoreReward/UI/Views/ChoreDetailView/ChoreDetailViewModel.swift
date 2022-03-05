//
//  ChoreDetailViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import Foundation
import Combine

class ChoreDetailViewModel: StatefulViewModel{
    @Published var _state: choreDetailState = empty
    static let empty: choreDetailState = .init(chore: nil)
    var state: AnyPublisher<choreDetailState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    private let choreSerivce: ChoreService
    private let userService: UserService
    private let chore: Chore
        
    init(
        chore: Chore,
        choreService: ChoreService,
        userService: UserService
    ){
        self._state = .init(chore: chore)
        self.choreSerivce = choreService
        self.userService = userService
        self.chore = chore
    }
    
    func performAction(_ action: choreDetailAction) {
        switch action{
        case .takeChore:
            self.takeChore()
        case .completeChore:
            self.completeChore()
        }
    }
    
    private func takeChore(){
        choreSerivce.takeChore(
            choreId: chore.id,
            currentUserId: userService.currentUserId 
        )
    }
    
    private func completeChore(){
        choreSerivce.completeChore(choreId: chore.id)
    }
}

struct choreDetailState{
    let chore: Chore?
}

enum choreDetailAction{
    //case someAction(parameter: ParameterType)
    case takeChore
    case completeChore
}

extension Dependency.ViewModels{
    func choreDetailViewModel(chore: Chore) -> ChoreDetailViewModel{
        ChoreDetailViewModel(
            chore: chore,
            choreService: services.choreService,
            userService: services.userService
        )
    }
}
