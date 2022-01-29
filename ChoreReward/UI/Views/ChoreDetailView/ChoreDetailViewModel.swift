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
    static let empty: choreDetailState = .init()
    var state: AnyPublisher<choreDetailState, Never>{
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

    func performAction(_ action: choreDetailAction) {
        // switch action {
        // case .createChore(let choreTitle):
        //     choreService.createChore(choreTitle: choreTitle)
        // }
    }
}

struct choreDetailState{
    //let something: SOMETHING
}

enum choreDetailAction{
    //case someAction(parameter: ParameterType)
}

extension Dependency.ViewModels{
    var choreDetailViewModel: ChoreDetailViewModel{
        ChoreDetailViewModel()
    }
}