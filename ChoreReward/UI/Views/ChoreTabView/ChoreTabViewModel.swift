//
//  ChoreTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

class ChoreTabViewModel: StatefulViewModel{
    @Published var _state: Void = ()
    static var empty: Void = ()
    var state: AnyPublisher<Void, Never>{
        return $_state.eraseToAnyPublisher()
    }

    func performAction(_ action: ChoreTabAction) {}
}

enum ChoreTabAction{}

extension Dependency.ViewModels{
    var choreTabViewModel: ChoreTabViewModel{
        ChoreTabViewModel()
    }
}
