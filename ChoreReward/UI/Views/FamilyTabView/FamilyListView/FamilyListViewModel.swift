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
    let shouldRenderButtons: Bool
    
    private let familyService: FamilyService
    private let userService: UserService
    private var familyMemberSubscription: AnyCancellable?
    
    init(
        familyService: FamilyService,
        userService: UserService
    ){
        self.familyService = familyService
        self.userService = userService
        self.shouldRenderButtons = familyService.isCurrentUserAdminOfCurrentFamily()
        addSubscription()
    }
    
    func addSubscription(){
        familyMemberSubscription = familyService.$currentFamilyMembers
            .sink(receiveValue: { [weak self] receivedFamilyMembers in
                self?.members = receivedFamilyMembers
            })
    }
}

extension Dependency.ViewModels{
    var familyListViewModel: FamilyListViewModel{
        FamilyListViewModel(
            familyService: services.familyService,
            userService: services.userService
        )
    }
}
