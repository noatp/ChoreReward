//
//  UserGoalView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import SwiftUI

struct UserRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userRewardViewModel: ObservableViewModel<UserRewardViewState, UserRewardViewAction>
    @State var presentSheet: Bool = false
    @State var rewardName: String = ""
    @State var rewardValue: String = ""

    private var views: Dependency.Views

    init(
        userGoalViewModel: ObservableViewModel<UserRewardViewState, UserRewardViewAction>,
        views: Dependency.Views
    ) {
        self.userRewardViewModel = userGoalViewModel
        self.views = views
    }

    var body: some View {
        RegularNavBarView(navTitle: "Reward") {
            ButtonView(buttonImage: "chevron.left") {
                dismiss()
            }
        } rightItem: {
            ButtonView(buttonImage: "plus") {
                presentSheet = true
            }
        } content: {
            VStack(alignment: .leading) {
                Text(String(format: "Current balance is ", userRewardViewModel.state.balance))
                    .font(.system(size: 20, weight: .light, design: .default))
                + Text(String(format: "$%.2f", userRewardViewModel.state.balance))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(userRewardViewModel.state.rewards, id: \.name) {reward in
                            RewardCardView(
                                rewardName: reward.name,
                                rewardValue: reward.value,
                                userBalance: userRewardViewModel.state.balance)

                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $presentSheet) {
            VStack {
                TextFieldView(title: "Reward name", textInput: $rewardName)
                HStack {
                    Text("$")
                    TextFieldView(title: "Reward value", textInput: $rewardValue)
                }
                ButtonView(buttonTitle: "Add new reward") {
                    userRewardViewModel.perform(action: .addNewReward(name: rewardName, value: rewardValue))
                    dismiss()
                }
            }
            .padding()
        }
    }
}

struct UserGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UserRewardView(
            userGoalViewModel: ObservableViewModel(
                staticState: UserRewardViewState(rewards: [], balance: 0.00)
            ),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
    }
}

extension Dependency.Views {
    var userGoalView: UserRewardView {
        return UserRewardView(
            userGoalViewModel: ObservableViewModel(viewModel: viewModels.userGoalViewModel),
            views: self
        )
    }
}
