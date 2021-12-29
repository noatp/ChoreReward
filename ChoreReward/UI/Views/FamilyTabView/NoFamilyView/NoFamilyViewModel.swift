//
//  NoFamilyViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/26/21.
//

import Foundation
import Combine

class NoFamilyViewModel: ObservableObject{
    let shouldRenderButtons: Bool
    let currentUserId: String
    
    private let userService: UserService
    private let familyService: FamilyService
    
    init(
        userService: UserService,
        familyService: FamilyService
    ){
        self.userService = userService
        self.familyService = familyService
        self.shouldRenderButtons = userService.isCurrentUserParent()
        self.currentUserId = userService.currentUser?.id ?? ""
    }
    
    func createFamily(){
        familyService.createFamily()
    }
}

extension Dependency.ViewModels{
    var noFamilyViewModel: NoFamilyViewModel{
        NoFamilyViewModel(
            userService: services.userService,
            familyService: services.familyService
        )
    }
}
