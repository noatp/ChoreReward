//
//  ObservableViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

//ObservableViewMode can either be a StatefulViewModel or a staticState
class ObservableViewModel<State, Action>: ObservableObject{
    @Published var state: State
    
    var action: Action
    var cancellable: AnyCancellable?
    
    init(
        staticState: State,
        staticAction: Action
    ){
        self.state = staticState
        self.action = staticAction
    }

    init<VM: StatefulViewModel>(viewModel: VM) where VM.State == State, VM.Action == Action{
        self.state = VM.empty
        self.action = viewModel.action
        self.cancellable = viewModel.state
            .sink(receiveValue: { [weak self] state in
                self?.state = state
            })
    }
    
}

protocol StatefulViewModel{
    associatedtype State
    associatedtype Action
    
    var state: AnyPublisher<State, Never> {get}
    var action: Action {get}
    
    static var empty: State {get}
}

