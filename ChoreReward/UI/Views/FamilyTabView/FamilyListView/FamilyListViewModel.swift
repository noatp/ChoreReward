//
//  FamilyListViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import Foundation
import Combine

class FamilyListViewModel: ObservableObject{
    @Published var members: [String]?
    
    private let familyService: FamilyService
    private var currentFamilySubscription: AnyCancellable?
    
    init(
        familyService: FamilyService
    ){
        self.familyService = familyService
        addSubscription()
    }
    
    func addSubscription(){
        currentFamilySubscription = familyService.$currentFamily
            .sink(receiveValue: {[weak self] receivedFamily in
                self?.members = receivedFamily?.members
            })
    }
    
}

extension Dependency.ViewModels{
    var familyListViewModel: FamilyListViewModel{
        FamilyListViewModel(familyService: services.familyService)
    }
}
