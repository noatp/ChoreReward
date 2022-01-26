//
//  ServiceManager.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/26/22.
//

import Foundation
import Combine

class ServiceManager{
    private let userSerivce: UserService
    private let familyService: FamilyService
    private let choreService: ChoreService
    
    private var currentUserSubscription: AnyCancellable?
    
    init(
        userSerivce: UserService,
        familyService: FamilyService,
        choreService: ChoreService
    ){
        print("init")
        self.userSerivce = userSerivce
        self.familyService = familyService
        self.choreService = choreService
        addSubscription()
    }
    
    private func addSubscription(){
        currentUserSubscription = userSerivce.$currentUser
            .sink(receiveValue: { [weak self] receivedUser in
                guard let currentUser = receivedUser else{
                    print("ServiceManager: currentUserSubscription: received nil")
                    return
                }
                print("ServiceManager: currentUserSubscription: received a new user record")
                self?.familyService.readCurrentFamily(currentUser: currentUser)
            })
        
    }
    
}
