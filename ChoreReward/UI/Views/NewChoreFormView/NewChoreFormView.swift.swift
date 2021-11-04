//
//  NewChoreFormView.swift.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/3/21.
//

import SwiftUI

struct NewChoreFormView: View {
    @ObservedObject private var newChoreFormViewModel : NewChoreFormViewModel
    
    init() {
        newChoreFormViewModel = NewChoreFormViewModel()
    }
    
    
    /*id: UUID().uuidString,
     title: "Wash the dishes",
     finished: false,
     choreBefore: "unfinishedDishes",
     choreAfter: "finishedDishes",
     whoCanTakeThis: "Timothy, Benjamin",
     whoTookThis: "",
     reward: Reward(unit: "Dollar", amount: 100))*/
    var body: some View {
        Form {
            Section(header: Text("Chore Information")) {
                TextFieldView(textFieldViewModel: self.newChoreFormViewModel.choreTitleTextVM)
//                Picker("Notify Me About", selection: $notifyMeAbout) {
//                    Text("Direct Messages").tag(0)
//                    Text("Mentions").tag(1)
//                    Text("Anything").tag(2)
//                }
//                Toggle("Send read receipts", isOn: $sendReadReceipts)
            }
        }
    }
}

struct NewChoreFormView_swift_Previews: PreviewProvider {
    static var previews: some View {
        NewChoreFormView()
    }
}
