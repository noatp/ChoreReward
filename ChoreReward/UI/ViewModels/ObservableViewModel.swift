//
//  ObservableViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

// ObservableViewMode can either be a StatefulViewModel or a staticState
class ObservableViewModel<ViewState, ViewAction>: ObservableObject {
    @Published var viewState: ViewState?

    private let actionExecutor: (ViewAction) -> Void
    var cancellable: AnyCancellable?

    init(
        staticState: ViewState
    ) {
        self.viewState = staticState
        self.actionExecutor = {_ in }
    }

    init<VM: StatefulViewModel>(viewModel: VM) where VM.ViewState == ViewState, VM.ViewAction == ViewAction {
        self.viewState = nil
        self.actionExecutor = {action in viewModel.performAction(action)}
        self.cancellable = viewModel.viewState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                self?.viewState = state
            })
    }

    func perform(action: ViewAction) {
        actionExecutor(action)
    }
}

protocol StatefulViewModel {
    associatedtype ViewState
    associatedtype ViewAction

    var viewState: AnyPublisher<ViewState, Never> {get}
    func performAction(_ viewAction: ViewAction)
}
