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
    private var currentFamilySubscription: AnyCancellable?
    
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
                    self?.familyService.resetCache()
                    self?.choreService.resetCache()
                    return
                }
                print("ServiceManager: currentUserSubscription: received a new user")
                self?.familyService.readCurrentFamily(currentUser: currentUser)
            })
        
        currentFamilySubscription = familyService.$currentFamily
            .sink(receiveValue: { [weak self] receivedFamily in
                guard let currentFamily = receivedFamily else{
                    print("ServiceManager: currentFamilySubscription: received nil")
                    return
                }
                print("ServiceManager: currentFamilySubscription: received a new family")
                self?.getMembersOfCurrentFamily(currentFamily: currentFamily)
                self?.getChoresOfCurrentFamily(currentFamily: currentFamily)
            })
    }
    
    private func getMembersOfCurrentFamily(currentFamily: Family) {
        Task{
            await familyService.getMembersOfCurrentFamily(currentFamily: currentFamily)
        }
    }
    
    private func getChoresOfCurrentFamily(currentFamily: Family){
        Task{
            await choreService.getChoresOfCurrentFamily(currentFamily: currentFamily)
        }
    }
    
}
