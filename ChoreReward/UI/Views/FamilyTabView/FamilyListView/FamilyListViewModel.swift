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
    
    private let familyService: FamilyService
    private var familyMemberSubscription: AnyCancellable?
    
    init(
        familyService: FamilyService
    ){
        self.familyService = familyService
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
        FamilyListViewModel(familyService: services.familyService)
    }
}
