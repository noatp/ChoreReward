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
    
    private let actionExecutor: (Action) -> Void
    var cancellable: AnyCancellable?
    
    init(
        staticState: State
    ){
        self.state = staticState
        self.actionExecutor = {_ in }
    }

    init<VM: StatefulViewModel>(viewModel: VM) where VM.State == State, VM.Action == Action{
        self.state = VM.empty
        self.actionExecutor = {action in viewModel.performAction(action)}
        self.cancellable = viewModel.state
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                self?.state = state
            })
    }
    
    func perform(action: Action){
        actionExecutor(action)
    }
}

protocol StatefulViewModel{
    associatedtype State
    associatedtype Action
    
    var state: AnyPublisher<State, Never> {get}
    func performAction(_ action: Action)
    
    static var empty: State {get}
}

