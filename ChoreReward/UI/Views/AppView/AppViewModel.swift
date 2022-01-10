//
//  AppViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/27/21.
//

import Foundation
import Combine

class AppViewModel: StatefulViewModel{
    @Published var _state: Void = empty
    var state: AnyPublisher<Void, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    func performAction(_ action: Void) {}
    
    static let empty: Void = ()
}

extension Dependency.ViewModels{
    var appViewModel: AppViewModel{
        AppViewModel()
    }
}
