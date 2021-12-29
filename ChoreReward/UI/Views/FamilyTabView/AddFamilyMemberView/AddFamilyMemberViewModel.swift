//
//  AddFamilyMemberViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/28/21.
//

import Foundation
import Combine

class AddFamilyMemberViewModel: ObservableObject{
    let userIdInputRender = TextFieldViewModel(title: "UserID", prompt: "UserID")
    
    private let familyService: FamilyService
    
    init(
        familyService: FamilyService
    ){
        self.familyService = familyService
    }
    
    func addMember(){
        familyService.addUserByIdToFamily(userId: userIdInputRender.textInput)
    }
}

extension Dependency.ViewModels{
    var addFamilyMemberViewModel: AddFamilyMemberViewModel{
        AddFamilyMemberViewModel(familyService: services.familyService)
    }
}
