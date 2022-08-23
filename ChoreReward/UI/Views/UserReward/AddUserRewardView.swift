//
//  AddUserRewardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/20/22.
//

import SwiftUI

// MARK: Main Implementaion

struct AddUserRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var addUserRewardViewModel: ObservableViewModel<Void, AddUserRewardAction>
    @State var shouldShowAlert: Bool = false
    @State var rewardName: String = ""
    @State var rewardValue: String = ""
    @FocusState private var focusedField: AddUserRewardFields?

    private var views: Dependency.Views

    init(
        addUserRewardViewModel: ObservableViewModel<Void, AddUserRewardAction>,
        views: Dependency.Views
    ) {
        self.addUserRewardViewModel = addUserRewardViewModel
        self.views = views
    }

    var body: some View {
        Form {
            RegularTextField(title: "Reward name", textInput: $rewardName)
                .submitLabel(.next)
                .focused($focusedField, equals: .rewardName)
                .onSubmit {
                    focusedField = .rewardAmount
                }
            HStack {
                Text("$")
                RegularTextField(title: "Reward value", textInput: $rewardValue)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
                    .focused($focusedField, equals: .rewardAmount)
                    .onSubmit {
                        addNewRewardAndDismiss()
                    }
            }
        }
        .vNavBar(NavigationBar(
            title: "Add reward",
            leftItem: dismissButton,
            rightItem: addRewardButton
        ))
        .alert(
            "Please fill out all information.",
            isPresented: $shouldShowAlert) {
                RegularButton(buttonTitle: "OK", action: {})
            }
    }
}

// MARK: Preview

struct AddUserRewardView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserRewardView(
            addUserRewardViewModel: ObservableViewModel(staticState: nil),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    var addUserRewardView: AddUserRewardView {
        return AddUserRewardView(
            addUserRewardViewModel: ObservableViewModel(viewModel: viewModels.addUserRewardViewModel),
            views: self
        )
    }
}

// MARK: Subviews

extension AddUserRewardView {
    var dismissButton: some View {
        CircularButton(action: {
            dismiss()
        }, icon: "xmark")
    }

    var addRewardButton: some View {
        RegularButton(buttonTitle: "Add") {
            if missingInfo() {
                shouldShowAlert = true
                return
            }
            addNewRewardAndDismiss()
        }
    }
}

// MARK: Additional functionality

extension AddUserRewardView {
    private func addNewRewardAndDismiss() {
        addUserRewardViewModel.perform(action: .addNewReward(name: rewardName, value: rewardValue))
        dismiss()
    }

    private func missingInfo() -> Bool {
        return rewardName.isEmpty || rewardValue.isEmpty
    }

    private enum AddUserRewardFields: Int, Hashable {
        case rewardName, rewardAmount
    }
}
