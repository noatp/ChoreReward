//
//  NewChoreFormViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation

class NewChoreFormViewModel: ObservableObject{
    var choreTitleTextVM: TextFieldViewModel
    
    init() {
        choreTitleTextVM = TextFieldViewModel(
            title: "Chore name",
            prompt: "What chore do you want to assign?"
        )
    }
}
