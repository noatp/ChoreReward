//
//  RootViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import Foundation
import Combine

class RootViewModel: ObservableObject{
    @Published var shouldRenderLoginView: Bool = true
    
    private var loginUseCase: LoginUseCase
    private var useCaseSubscription: AnyCancellable?
    
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
        addSubscription()
    }
    
    func addSubscription(){
        useCaseSubscription = loginUseCase.$result
            .sink(receiveValue: { useCaseResult in
                switch useCaseResult{
                case .success(let uid):
                    if (uid != nil){
                        self.shouldRenderLoginView = false
                    }
                    else{
                        self.shouldRenderLoginView = true
                    }
                case .error(_):
                    self.shouldRenderLoginView = true
                }
            })
    }
}

extension Dependency.ViewModels{
    var rootViewModel: RootViewModel{
        RootViewModel(loginUseCase: useCases.loginUseCase)
    }
}
