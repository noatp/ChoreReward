//
//  ChoreTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine

class ChoreTabViewModel: StatefulViewModel {
    @Published private var _state: ChoreTabState?
    var viewState: AnyPublisher<ChoreTabState?, Never> {
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
                guard let receivedFamilyChores = receivedFamilyChores else {
                    return
                }

                if let oldState = self?._state {
                    self?._state = .init(
                        displayingChoreList: self?.applyFilterAndPicker(
                            filterState: oldState.choreFilterState,
                            pickerState: oldState.chorePickerState,
                            choreList: receivedFamilyChores
                        ) ?? [],
                        choreFilterState: oldState.choreFilterState,
                        chorePickerState: oldState.chorePickerState,
                        deletableChore: self?.userService.currentUser?.role != .child,
                        shouldShowAddChorePrompt: self?.userService.currentUser?.role != .child
                    )
                } else {
                    self?._state = .init(
                        displayingChoreList: self?.applyFilterAndPicker(
                            filterState: .all,
                            pickerState: .unfinished,
                            choreList: receivedFamilyChores
                        ) ?? [],
                        choreFilterState: .all,
                        chorePickerState: .unfinished,
                        deletableChore: self?.userService.currentUser?.role != .child,
                        shouldShowAddChorePrompt: self?.userService.currentUser?.role != .child
                    )
                }
            })
    }

    private func applyFilterToChoreList(filterState: ChoreFilterState, choreList: [Chore]) -> [Chore] {
        switch filterState {
        case .all:
            return choreList
        case .youPicked:
            return choreList.filter { chore in
                chore.assignee?.id == userService.currentUserId
            }
        case .youPosted:
            return choreList.filter { chore in
                chore.assigner.id == userService.currentUserId
            }
        }
    }

    private func applyPickerToChoreList(pickerState: ChorePickerState, choreList: [Chore]) -> [Chore] {
        switch pickerState {
        case .finished:
            return choreList.filter { chore in
                chore.finished != nil
            }
        case .unfinished:
            return choreList.filter { chore in
                chore.finished == nil
            }
        }
    }

    private func applyFilterAndPicker(
        filterState: ChoreFilterState,
        pickerState: ChorePickerState,
        choreList: [Chore]) -> [Chore] {
        return applyFilterToChoreList(
            filterState: filterState,
            choreList: applyPickerToChoreList(
                pickerState: pickerState,
                choreList: choreList
            ).sorted(by: { firstChore, secondChore in
                firstChore.created > secondChore.created
            })
        )
    }

    private func updateFilterState(_ newState: ChoreFilterState) {
        guard let oldState = _state else {
            return
        }
        _state = .init(
            displayingChoreList: applyFilterAndPicker(
                filterState: newState,
                pickerState: oldState.chorePickerState,
                choreList: choreService.familyChores ?? []
            ),
            choreFilterState: newState,
            chorePickerState: oldState.chorePickerState,
            deletableChore: oldState.deletableChore,
            shouldShowAddChorePrompt: oldState.shouldShowAddChorePrompt
        )
    }

    private func updatePickerState(_ newState: ChorePickerState) {
        guard let oldState = _state else {
            return
        }
        _state = .init(
            displayingChoreList: applyFilterAndPicker(
                filterState: oldState.choreFilterState,
                pickerState: newState,
                choreList: choreService.familyChores ?? []
            ),
            choreFilterState: oldState.choreFilterState,
            chorePickerState: newState,
            deletableChore: oldState.deletableChore,
            shouldShowAddChorePrompt: oldState.shouldShowAddChorePrompt
        )
    }

    private func delete(choreAtOffsets offsets: IndexSet) {
        guard let currentUser = userService.currentUser,
              let viewState = _state,
              currentUser.role != .child
        else {
            return
        }
        for offset in offsets {
            let choreToDelete = viewState.displayingChoreList[offset]
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
    let displayingChoreList: [Chore]
    let choreFilterState: ChoreFilterState
    let chorePickerState: ChorePickerState
    let deletableChore: Bool
    let shouldShowAddChorePrompt: Bool

    static let preview: ChoreTabState = .init(
        displayingChoreList: [.previewChoreFinished, .previewChoreUnfinished, .previewChoreFinished_1],
        choreFilterState: .all,
        chorePickerState: .unfinished,
        deletableChore: false,
        shouldShowAddChorePrompt: false
    )
}

enum ChoreTabAction {
    case updatePickerState(ChorePickerState)
    case updateFilterState(ChoreFilterState)
    case deleteChore(IndexSet)
    case refreshChoreList
}

enum ChoreFilterState: CaseIterable {
    case all, youPicked, youPosted
    var label: String {
        switch self {
        case .all:
            return "All"
        case .youPicked:
            return "You Picked"
        case .youPosted:
            return "You Posted"
        }
    }
    var icon: String {
        switch self {
        case .all:
            return "list.bullet"
        case .youPosted:
            return "plus.bubble"
        case .youPicked:
            return "star.bubble"
        }
    }
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
