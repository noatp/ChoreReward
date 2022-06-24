//
//  UserGoalView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import SwiftUI

// MARK: Main Implementaion

struct UserRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userRewardViewModel: ObservableViewModel<UserRewardViewState, UserRewardViewAction>
    @State var presentSheet: Bool = false

    private var views: Dependency.Views

    init(
        userGoalViewModel: ObservableViewModel<UserRewardViewState, UserRewardViewAction>,
        views: Dependency.Views
    ) {
        self.userRewardViewModel = userGoalViewModel
        self.views = views
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(String(format: "Current balance is ", userRewardViewModel.state.balance))
                .font(StylingFont.regular)
            + Text(String(format: "$%.2f", userRewardViewModel.state.balance))
                .font(StylingFont.title)
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(userRewardViewModel.state.rewards, id: \.name) {reward in
                        RewardCardView(
                            rewardName: reward.name,
                            rewardValue: reward.value,
                            userBalance: userRewardViewModel.state.balance
                        )

                    }
                }
            }
        }
        .padding()
        .vNavBar(NavigationBar(
            title: "Reward",
            leftItem: backButton,
            rightItem: addRewardButton)
        )
        .fullScreenCover(isPresented: $presentSheet) {
            views.addUserRewardView
        }
    }
}

// MARK: Preview

struct UserGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UserRewardView(
            userGoalViewModel: ObservableViewModel(
                staticState: UserRewardViewState(rewards: [], balance: 0.00)
            ),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    var userGoalView: UserRewardView {
        return UserRewardView(
            userGoalViewModel: ObservableViewModel(viewModel: viewModels.userGoalViewModel),
            views: self
        )
    }
}

// MARK: Subviews

extension UserRewardView {
    private var backButton: some View {
        RegularButtonView(buttonImage: "chevron.left") {
            dismiss()
        }
    }

    private var addRewardButton: some View {
        RegularButtonView(buttonImage: "plus") {
            presentSheet = true
        }

    }
}
