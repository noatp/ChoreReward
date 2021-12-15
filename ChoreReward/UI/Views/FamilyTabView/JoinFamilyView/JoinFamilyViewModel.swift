//
//  JoinFamilyViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/14/21.
//

import Foundation

class JoinFamilyViewModel: ObservableObject{
    
    private let familyService: FamilyService
    
    let familyIdInputRender = TextFieldViewModel(title: "FamilyID", prompt: "Please input family ID")
    
    init(
        familyService: FamilyService
    ){
        self.familyService = familyService
    }
    
    func joinFamilyWithId(){
    }
}

extension Dependency.ViewModels{
    var joinFamilyViewModel: JoinFamilyViewModel{
        JoinFamilyViewModel(familyService: services.familyService)
    }
}
