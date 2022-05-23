//
//  EditUserProfileViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/20/22.
//

import Foundation
import Combine
import SwiftUI

class EditUserProfileViewModel: StatefulViewModel{
    @Published var _state: EditUserProfileState = empty
    static let empty = EditUserProfileState.empty
    var state: AnyPublisher<EditUserProfileState, Never>{
        return $_state.eraseToAnyPublisher()
    }

    private let userService: UserService
    private var currentUserSubscription: AnyCancellable?
        
    init(
        userService: UserService
    ){
        self.userService = userService
        self.addSubscription()
    }
    
    func addSubscription(){
        currentUserSubscription = userService.$currentUser
            .sink(receiveValue: { receivedUser in
                guard let currentUser = receivedUser else{
                    print("\(#fileID) \(#function): currentUser is nil")
                    return
                }
                self._state = .init(
                    currentUserEmail: currentUser.email,
                    currentUserName: currentUser.name,
                    currentUserRole: currentUser.role.rawValue,
                    currentUserProfileImageUrl: currentUser.profileImageUrl
                )
            })
    }
    private func updateUserProfile(
        userName: String,
        userEmail: String,
        newUserImage: UIImage?,
        didChangeProfileImage: Bool
    ){
        guard let currentUser = userService.currentUser else{
            print("\(#fileID) \(#function): currentuser is nil")
            return
        }
        let newUserProfile = User(
            email: userEmail.isEmpty ? currentUser.email : userEmail,
            name: userName.isEmpty ? currentUser.name : userName,
            role: currentUser.role
        )
        if didChangeProfileImage{
            userService.updateUserProfileWithImage(newUserProfile: newUserProfile, newUserImage: newUserImage)
        }
        else{
            userService.updateUserProfileWithoutImage(newUserProfile: newUserProfile)
        }
    }
    
    func performAction(_ action: EditUserProfileAction) {
        switch(action){
        case .updateUserProfile(let userName, let userEmail, let userImage, let didChangeProfileImage):
            updateUserProfile(
                userName: userName,
                userEmail: userEmail,
                newUserImage: userImage,
                didChangeProfileImage: didChangeProfileImage
            )
        }
    }
}

struct EditUserProfileState {
    let currentUserEmail: String
    let currentUserName: String
    let currentUserRole: String
    let currentUserProfileImageUrl: String?
    
    static let empty: EditUserProfileState = .init(
        currentUserEmail: "",
        currentUserName: "",
        currentUserRole: "",
        currentUserProfileImageUrl: nil
    )
    
    static let preview: EditUserProfileState = .init(
        currentUserEmail: "toan.chpham@gmail.com",
        currentUserName: "Toan Pham",
        currentUserRole: Role.child.rawValue,
        currentUserProfileImageUrl: nil
    )
}

enum EditUserProfileAction{
    case updateUserProfile(userName: String, userEmail: String, userImage: UIImage?, didChangeProfileImage: Bool)
}

extension Dependency.ViewModels{
    var editUserProfileViewModel: EditUserProfileViewModel{
        EditUserProfileViewModel(userService: services.userService)
    }
}
