//
//  FamilyTabViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import Foundation
import Combine

class FamilyTabViewModel: ObservableObject{
    @Published var currentFamily: Family? = nil
    
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
                print("received a new family here", receivedFamily)
                self?.currentFamily = receivedFamily
            })
    }
    
    func createFamily(){
        print("create family called here")
        familyService.createFamily()
    }
}

extension Dependency.ViewModels{
    var familyTabViewModel: FamilyTabViewModel{
        FamilyTabViewModel(familyService: services.familyService)
    }
}
