//
//  ChoreTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

class ChoreTabViewModel: StatefulViewModel {
    @Published private var _state: ChoreTabState = empty
    static var empty: ChoreTabState = .empty

    var state: AnyPublisher<ChoreTabState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let choreService: ChoreService
    private let userService: UserService
    private var choreListSubscription: AnyCancellable?

    init(
        choreService: ChoreService,
        userService: UserService
    ) {
        self.choreService = choreService
        self.userService = userService
        addSubscription()
    }

    func addSubscription() {
        choreListSubscription = choreService.$familyChores
            .sink(receiveValue: { [weak self] receivedFamilyChores in
                guard let oldState = self?._state, let familyChores = receivedFamilyChores else {
                    return
                }
                self?._state = .init(
                    displayingChoreList: self?.applyFilterAndPicker(
                        filterState: oldState.choreFilterState,
                        pickerState: oldState.chorePickerState,
                        choreList: familyChores
                    ) ?? [],
                    choreFilterState: oldState.choreFilterState,
                    chorePickerState: oldState.chorePickerState
                )
            })
    }

    private func applyFilterToChoreList(filterState: ChoreFilterState, choreList: [Chore]) -> [Chore] {
        switch filterState {
        case .all:
            return choreList
        case .takenByCurrentUser:
            return choreList.filter { chore in
                chore.assigneeId == userService.currentUserId
            }
        }
    }

    private func applyPickerToChoreList(pickerState: ChorePickerState, choreList: [Chore]) -> [Chore] {
        switch pickerState {
        case .finished:
            return choreList.filter { chore in
                chore.completed != nil
            }
        case .unfinished:
            return choreList.filter { chore in
                chore.completed == nil
            }
        }
    }

    private func applyFilterAndPicker(filterState: ChoreFilterState, pickerState: ChorePickerState, choreList: [Chore]) -> [Chore] {
        return applyFilterToChoreList(
            filterState: filterState,
            choreList: applyPickerToChoreList(
                pickerState: pickerState,
                choreList: choreList
            )
        )
    }

    private func updateFilterState(_ newState: ChoreFilterState) {
        let oldState = _state

        _state = .init(
            displayingChoreList: applyFilterAndPicker(
                filterState: newState,
                pickerState: oldState.chorePickerState,
                choreList: choreService.familyChores ?? []
            ),
            choreFilterState: newState,
            chorePickerState: oldState.chorePickerState
        )
    }

    private func updatePickerState(_ newState: ChorePickerState) {
        let oldState = _state

        _state = .init(
            displayingChoreList: applyFilterAndPicker(
                filterState: oldState.choreFilterState,
                pickerState: newState,
                choreList: choreService.familyChores ?? []
            ),
            choreFilterState: oldState.choreFilterState,
            chorePickerState: newState
        )
    }

    func performAction(_ action: ChoreTabAction) {
        switch action {
        case .updateFilterState(let choreFilterState):
            updateFilterState(choreFilterState)
        case .updatePickerState(let chorePickerState):
            updatePickerState(chorePickerState)
        }
    }
}

struct ChoreTabState {
    let displayingChoreList: [Chore]
    let choreFilterState: ChoreFilterState
    let chorePickerState: ChorePickerState

    static let empty: ChoreTabState = .init(
        displayingChoreList: [],
        choreFilterState: .all,
        chorePickerState: .unfinished
    )
}

enum ChoreTabAction {
    case updatePickerState(ChorePickerState)
    case updateFilterState(ChoreFilterState)
}

enum ChoreFilterState {
    case all, takenByCurrentUser
}

enum ChorePickerState {
    case finished, unfinished
}

extension Dependency.ViewModels {
    var choreTabViewModel: ChoreTabViewModel {
        ChoreTabViewModel(
            choreService: services.choreService,
            userService: services.userService
        )
    }
}
