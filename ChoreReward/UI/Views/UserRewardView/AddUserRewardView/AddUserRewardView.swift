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
    @ObservedObject var addUserRewardViewModel: ObservableViewModel<AddUserRewardState, AddUserRewardAction>
    @State var rewardName: String = ""
    @State var rewardValue: String = ""
    @FocusState private var focusedField: AddUserRewardFields?

    private var views: Dependency.Views

    init(
        addUserRewardViewModel: ObservableViewModel<AddUserRewardState, AddUserRewardAction>,
        views: Dependency.Views
    ) {
        self.addUserRewardViewModel = addUserRewardViewModel
        self.views = views
    }

    var body: some View {
        VStack {
            Spacer()
            TextFieldView(title: "Reward name", textInput: $rewardName)
                .submitLabel(.next)
                .focused($focusedField, equals: .name)
                .onSubmit {
                    focusedField = .rewardAmount
                }

            HStack {
                Text("$")
                TextFieldView(title: "Reward value", textInput: $rewardValue)
                    .submitLabel(.done)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .rewardAmount)
                    .onSubmit {
                        focusedField = .none
                        addNewReward()
                    }
            }
            Spacer()
        }
        .padding()
        .vNavBar(NavigationBar(
            title: "Add reward",
            leftItem: dismissButton,
            rightItem: addRewardButton
        ))
    }
}

// MARK: Preview

struct AddUserRewardView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserRewardView(
            addUserRewardViewModel: ObservableViewModel(
                staticState: AddUserRewardState()
            ),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
        .font(StylingFont.regular)
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
        RegularButton(buttonTitle: "Done") {
            addNewReward()
        }
    }
}

// MARK: Additional functionality

extension AddUserRewardView {
    private func addNewReward() {
        addUserRewardViewModel.perform(action: .addNewReward(name: rewardName, value: rewardValue))
        dismiss()
    }

    private enum AddUserRewardFields: Int, Hashable {
        case name, rewardAmount
    }
}
