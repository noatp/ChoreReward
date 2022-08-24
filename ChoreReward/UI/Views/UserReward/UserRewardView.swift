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
        UnwrapViewState(viewState: userRewardViewModel.viewState) { viewState in
            VStack(alignment: .leading) {
                Text("Your current balance is ")
                    .font(StylingFont.headline)
                + Text("$\(viewState.balance)")
                    .font(StylingFont.smallTitle)
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewState.rewards, id: \.name) {reward in
                            RewardCard(
                                rewardName: reward.name,
                                rewardValue: reward.value,
                                userBalance: viewState.balance
                            )
                        }
                    }
                }
            }
            .padding(StylingSize.largePadding)
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
}

// MARK: Preview

struct UserGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UserRewardView(
            userGoalViewModel: ObservableViewModel(staticState: .preview),
            views: Dependency.preview.views()
        )

        UserRewardView(
            userGoalViewModel: ObservableViewModel(staticState: .preview),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
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
        CircularButton(action: {
            dismiss()
        }, icon: "chevron.left")
    }

    private var addRewardButton: some View {
        CircularButton(action: {
            presentSheet = true
        }, icon: "plus")
    }
}
