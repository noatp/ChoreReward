//
//  FamilyListViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import Foundation
import Combine

class FamilyListViewModel: ObservableObject{
    @Published var members: [User] = []
    
    private let userService: UserService
    private var familyMemberSubscription: AnyCancellable?
    
    init(
        userService: UserService
    ){
        self.userService = userService
        addSubscription()
    }
    
    func addSubscription(){
        familyMemberSubscription = userService.$currentFamilyMembers
            .sink(receiveValue: { [weak self] receivedFamilyMembers in
                self?.members = receivedFamilyMembers
            })
    }
}

extension Dependency.ViewModels{
    var familyListViewModel: FamilyListViewModel{
        FamilyListViewModel(userService: services.userService)
    }
}
