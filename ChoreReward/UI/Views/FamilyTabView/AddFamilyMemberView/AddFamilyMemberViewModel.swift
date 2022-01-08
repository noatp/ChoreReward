//
//  AddFamilyMemberViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/6/22.
//

import Foundation
import Combine
import SwiftUI

class AddFamilyMemberViewModel: StatefulViewModel{
    typealias State = AddFamilyMemberState
    typealias Action = AddFamilyMemberAction

    static let empty = AddFamilyMemberState(userIdInput: "")

    @Published var _state: AddFamilyMemberState = empty
    var state: AnyPublisher<AddFamilyMemberState, Never>{
        return $_state.eraseToAnyPublisher()
    }
    var action: AddFamilyMemberAction{
        return AddFamilyMemberAction(
            addMember: addMember,
            updateUserIdInput: updateUserIdInput
        )
    }
    
    private let familyService: FamilyService
    
    init(
        familyService: FamilyService
    ){
        self.familyService = familyService
    }
    
    private func addMember(){
        familyService.addUserByIdToFamily(userId: _state.userIdInput)
    }
    
    private func updateUserIdInput(newValue: String){
        self._state = AddFamilyMemberState(userIdInput: newValue)
    }
}

struct AddFamilyMemberState{
    var userIdInput: String
}

struct AddFamilyMemberAction{
    let addMember: () -> Void
    let updateUserIdInput: (String) -> Void
}

extension Dependency.ViewModels{
    var addFamilyMemberViewModel: AddFamilyMemberViewModel{
        AddFamilyMemberViewModel(familyService: services.familyService)
    }
}
