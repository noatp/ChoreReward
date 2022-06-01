//
//  FamilyTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import Combine

class FamilyTabViewModel: StatefulViewModel {
    @Published var _state: FamilyTabState = empty
    static let empty = FamilyTabState(hasCurrentFamily: false)
    var state: AnyPublisher<FamilyTabState, Never> {
        return $_state.eraseToAnyPublisher()
    }

    private let familyService: FamilyService
    private var currentFamilySubscription: AnyCancellable?

    init(
        familyService: FamilyService
    ) {
        self.familyService = familyService
        addSubscription()
    }

    func addSubscription() {
        currentFamilySubscription = familyService.$currentFamily
            .sink(receiveValue: {[weak self] receivedFamily in
                guard receivedFamily != nil else {
                    self?._state = .init(hasCurrentFamily: false)
                    return
                }
                self?._state = .init(hasCurrentFamily: true)
            })
    }

    func performAction(_ action: Void) {}
}

struct FamilyTabState {
    let hasCurrentFamily: Bool
}

extension Dependency.ViewModels {
    var familyTabViewModel: FamilyTabViewModel {
        FamilyTabViewModel(familyService: services.familyService)
    }
}
