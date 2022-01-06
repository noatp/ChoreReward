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
    
    var cancellable: AnyCancellable?
    
    var action: Action
    
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
    
    static var empty: State {get}
    
    var action: Action {get}
}

