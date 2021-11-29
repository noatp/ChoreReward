//
//  TextFieldViewModel.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/4/21.
//

import Foundation

class TextFieldViewModel: ObservableObject{
    @Published var textInput: String
    var title: String
    var prompt: String
    var secure: Bool
    
    static let preview = TextFieldViewModel(
        title: "Chore Name",
        prompt: "What chore do you want to assign?"
    )
    
    init(
        title: String,
        prompt: String = "",
        prefilledTextInput: String = "",
        secure: Bool = false
    ){
        self.title = title
        self.prompt = prompt
        self.textInput = prefilledTextInput
        self.secure = secure
    }
}
