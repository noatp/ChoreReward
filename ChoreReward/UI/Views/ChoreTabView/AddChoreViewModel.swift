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
    
    //private let something: SomeType
    //private var something: AnyCancellable?
    
    init(
        //some services
    ){
        self._state = .init()
        //addSubscription()
    }
    
    func addSubscription(){
    }

    func performAction(_ action: AddChoreAction) {
        // switch action {
        // case .createChore(let choreTitle):
        //     choreService.createChore(choreTitle: choreTitle)
        // }
    }
}

struct AddChoreState{
    //let something: SOMETHING
}

enum AddChoreAction{
    //case someAction(parameter: ParameterType)
}

extension Dependency.ViewModels{
    var addChoreViewModel: AddChoreViewModel{
        AddChoreViewModel()
    }
}