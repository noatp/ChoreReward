//
//  AddChoreViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/15/22.
//

import Foundation
import Combine

class AddChoreViewModel: StatefulViewModel{
    @Published var _state: AddChoreState = empty
    static let empty: AddChoreState = .init()
    var state: AnyPublisher<AddChoreState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    private let choreService: ChoreService
    private let userService: UserService
    
    init(
        choreService: ChoreService,
        userService: UserService
    ){
        self._state = .init()
        self.choreService = choreService
        self.userService = userService
    }

    func createChore(choreTitle: String){
        guard let currentUser = userService.currentUser else{
            return
        }
        Task{
            await choreService.createChore(choreTitle: choreTitle, currentUser: currentUser)
        }
    }
    
    func performAction(_ action: AddChoreAction) {
         switch action {
         case .createChore(let choreTitle):
             createChore(choreTitle: choreTitle)
         }
    }
}

struct AddChoreState{
    //let something: SOMETHING
}

enum AddChoreAction{
    case createChore(choreTitle: String)
}

extension Dependency.ViewModels{
    var addChoreViewModel: AddChoreViewModel{
        AddChoreViewModel(choreService: services.choreService, userService: services.userService)
    }
}
