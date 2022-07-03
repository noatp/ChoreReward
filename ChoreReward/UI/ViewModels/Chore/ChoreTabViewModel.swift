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
        choreListSubscription = choreService.$choreList
            .sink(receiveValue: { [weak self] receivedChoreList in
                guard let oldState = self?._state, let choreList = receivedChoreList else {
                    return
                }
                self?._state = .init(
                    choreList: self?.applyFilterAndPicker(
                        filterState: oldState.choreFilterState,
                        pickerState: oldState.chorePickerState,
                        choreList: choreList
                    ) ?? [],
                    choreFilterState: oldState.choreFilterState,
                    chorePickerState: oldState.chorePickerState,
                    deletableChore: self?.userService.currentUser?.role != .child
                )
            })
    }

    private func applyFilterToChoreList(filterState: ChoreFilterState, choreList: [DenormChore]) -> [DenormChore] {
        switch filterState {
        case .all:
            return choreList
        case .takenByCurrentUser:
            return choreList.filter { chore in
                chore.assigneeId == userService.currentUserId
            }
        }
    }

    private func applyPickerToChoreList(pickerState: ChorePickerState, choreList: [DenormChore]) -> [DenormChore] {
        switch pickerState {
        case .finished:
            return choreList.filter { chore in
                chore.finished
            }
        case .unfinished:
            return choreList.filter { chore in
                !chore.finished
            }
        }
    }

    private func applyFilterAndPicker(filterState: ChoreFilterState, pickerState: ChorePickerState, choreList: [DenormChore]) -> [DenormChore] {
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
            choreList: applyFilterAndPicker(
                filterState: newState,
                pickerState: oldState.chorePickerState,
                choreList: choreService.choreList ?? []
            ),
            choreFilterState: newState,
            chorePickerState: oldState.chorePickerState,
            deletableChore: oldState.deletableChore
        )
    }

    private func updatePickerState(_ newState: ChorePickerState) {
        let oldState = _state

        _state = .init(
            choreList: applyFilterAndPicker(
                filterState: oldState.choreFilterState,
                pickerState: newState,
                choreList: choreService.choreList ?? []
            ),
            choreFilterState: oldState.choreFilterState,
            chorePickerState: newState,
            deletableChore: oldState.deletableChore
        )
    }

    private func delete(choreAtOffsets offsets: IndexSet) {
        guard let currentUser = userService.currentUser,
              currentUser.role != .child
        else {
            return
        }
        for offset in offsets {
            let choreToDelete = self._state.choreList[offset]
            choreService.delete(choreAtId: choreToDelete.id, byUser: currentUser)
        }
    }

    private func refreshChoreList() {
        choreService.refreshChoreList()
    }

    func performAction(_ action: ChoreTabAction) {
        switch action {
        case .updateFilterState(let choreFilterState):
            updateFilterState(choreFilterState)
        case .updatePickerState(let chorePickerState):
            updatePickerState(chorePickerState)
        case .deleteChore(let offsets):
            delete(choreAtOffsets: offsets)
        case .refreshChoreList:
            refreshChoreList()
        }
    }
}

struct ChoreTabState {
    let choreList: [DenormChore]
    let choreFilterState: ChoreFilterState
    let chorePickerState: ChorePickerState
    let deletableChore: Bool

    static let empty: ChoreTabState = .init(
        choreList: [],
        choreFilterState: .all,
        chorePickerState: .unfinished,
        deletableChore: false
    )
}

enum ChoreTabAction {
    case updatePickerState(ChorePickerState)
    case updateFilterState(ChoreFilterState)
    case deleteChore(IndexSet)
    case refreshChoreList
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
