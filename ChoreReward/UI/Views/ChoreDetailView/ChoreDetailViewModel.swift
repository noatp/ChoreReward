//
//  ChoreDetailViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/28/22.
//

import Foundation
import Combine

class ChoreDetailViewModel: StatefulViewModel{
    @Published var _state: choreDetailState = empty
    static let empty: choreDetailState = .init(chore: nil)
    var state: AnyPublisher<choreDetailState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    private let choreSerivce: ChoreService
    
    private var choreSubscription: AnyCancellable?
    
    init(
        chore: Chore,
        choreService: ChoreService
    ){
        self._state = .init(chore: chore)
        self.choreSerivce = choreService
        self.readChore(choreId: chore.id!)
    }

    func addSubscription(){
        choreSubscription = choreSerivce.$chore
            .sink(receiveValue: {[weak self] receivedChore in
                self?._state = .init(chore: receivedChore)
            })
    }
    
    func performAction(_ action: choreDetailAction) {
        // switch action {
        // case .createChore(let choreTitle):
        //     choreService.createChore(choreTitle: choreTitle)
        // }
    }
    
    func readChore(choreId: String){
        choreSerivce.readChore(choreId: choreId)
    }
}

struct choreDetailState{
    let chore: Chore?
}

enum choreDetailAction{
    //case someAction(parameter: ParameterType)
}

extension Dependency.ViewModels{
    func choreDetailViewModel(chore: Chore) -> ChoreDetailViewModel{
        ChoreDetailViewModel(chore: chore, choreService: services.choreService)
    }
}
