//
//  ChoreTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

class ChoreTabViewModel: StatefulViewModel{
    func performAction(_ action: ChoreTabAction) {
        
    }

    static let empty = ChoreTabState(

    )

    @Published var _state: ChoreTabState = empty
    var state: AnyPublisher<ChoreTabState, Never>{
        return $_state.eraseToAnyPublisher()
    }
}

struct ChoreTabState{

}

enum ChoreTabAction{

}

extension Dependency.ViewModels{
    var choreTabViewModel: ChoreTabViewModel{
        ChoreTabViewModel()
    }
}
