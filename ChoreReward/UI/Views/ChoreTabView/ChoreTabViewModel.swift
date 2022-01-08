//
//  ChoreTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

class ChoreTabViewModel: StatefulViewModel{
    typealias State = ChoreTabState
    typealias Action = ChoreTabAction

    static let empty = ChoreTabState(

    )

    @Published var _state: ChoreTabState = empty
    var state: AnyPublisher<ChoreTabState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    var action: ChoreTabAction{
        return ChoreTabAction()
    }
    
    //private let something: SomeType
    //private var something: AnyCancellable?
    
    init(
        //some services
    ){
        //addSubscription()
    }
    
    func addSubscription(){
    }
}

struct ChoreTabState{

}

struct ChoreTabAction{

}

extension Dependency.ViewModels{
    var choreTabViewModel: ChoreTabViewModel{
        ChoreTabViewModel()
    }
}
