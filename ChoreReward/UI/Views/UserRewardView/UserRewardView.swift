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
    // @State var
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

            }
        } content: {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(userRewardViewModel.state.rewards, id: \.name) {reward in
                        HStack {
                            Text(reward.name)
                            Text("\(reward.value)")
                        }

                    }
                }
            }
        }

        .navigationBarHidden(true)

    }
}

struct UserGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UserRewardView(
            userGoalViewModel: ObservableViewModel(
                staticState: UserRewardViewState(rewards: [])
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
