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
    
    @State private var selectedRewardUnit = rewardUnit.percentOfCurrentGoal
    
    var body: some View {
        Form {
            Section(header: Text("Chore Information")) {
                TextFieldView(textFieldViewModel: self.newChoreFormViewModel.choreTitleTextVM)
                HStack{
                    TextFieldView(textFieldViewModel: self.newChoreFormViewModel.choreRewardCountTextVM)
                    Picker("Unit", selection: $selectedRewardUnit) {
                        Text("percent of current goal").tag(rewardUnit.percentOfCurrentGoal)
                        Text("dollar").tag(rewardUnit.dollar)
                    }
                    .pickerStyle(.menu)
                }
            }
        }
    }
}

struct NewChoreFormView_swift_Previews: PreviewProvider {
    static var previews: some View {
        NewChoreFormView()
    }
}
