//
//  FamilyService.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/13/21.
//

import Foundation
import Combine

class FamilyService: ObservableObject{
    @Published var currentFamily: Family? = nil
    
    private let userRepository: UserRepository
    private let familyRepository: FamilyRepository
    private var currentFamilySubscription: AnyCancellable?
    
    init(
        userRepository: UserRepository,
        familyRepository: FamilyRepository,
        initCurrentFamily: Family? = nil
    ){
        self.userRepository = userRepository
        self.familyRepository = familyRepository
        self.currentFamily = initCurrentFamily
        addSubscription()
    }
    
    func addSubscription(){
        currentFamilySubscription = familyRepository.$currentFamily
            .sink(receiveValue: {[weak self] receivedFamily in
                self?.currentFamily = receivedFamily
            })
    }
    
    func createFamily(){
        guard let currentUserId = userRepository.currentUser?.id else{
            print("cannot retrieve currentUserId")
            return
        }
        
        let newFamilyId = UUID().uuidString
        familyRepository.createFamily(currentUserId: currentUserId, newFamilyId: newFamilyId)
        userRepository.updateFamilyForCurrentUser(newFamilyId: newFamilyId)
    }
    
    func readCurrentFamily(){
        guard let currentFamilyId = userRepository.currentUser?.familyId else{
            print("cannot retrieve currnetFamilyId")
            return
        }
        
        familyRepository.readCurrentFamily(currentFamilyId: currentFamilyId)
    }
}
