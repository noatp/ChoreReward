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
    @Published var _state: Void = ()
    static var empty: Void = ()
    private let familyService: FamilyService
    var state: AnyPublisher<Void, Never>{
        return $_state.eraseToAnyPublisher()
    }
    
    init(
        familyService: FamilyService
    ){
        self.familyService = familyService
    }
    
    private func addMember(userId: String){
        familyService.addUserByIdToFamily(userId: userId)
    }
    
    func performAction(_ action: AddFamilyMemberAction) {
        switch action{
        case .addMember(let userId):
            self.addMember(userId: userId)
        }
    }
}
    
enum AddFamilyMemberAction{
    case addMember(userId: String)
}

extension Dependency.ViewModels{
    var addFamilyMemberViewModel: AddFamilyMemberViewModel{
        AddFamilyMemberViewModel(familyService: services.familyService)
    }
}
