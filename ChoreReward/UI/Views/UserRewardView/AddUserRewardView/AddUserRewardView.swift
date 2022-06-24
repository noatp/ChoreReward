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
            HStack {
                Text("$")
                TextFieldView(title: "Reward value", textInput: $rewardValue)
            }
            FilledButtonView(buttonTitle: "Add new reward") {
                addUserRewardViewModel.perform(action: .addNewReward(name: rewardName, value: rewardValue))
                dismiss()
            }
            Spacer()
        }
        .padding()
        .vNavBar(NavigationBar(
            title: "Add reward",
            leftItem: dismissButton,
            rightItem: EmptyView()
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
}
