//
//  UserGoalView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/18/22.
//

import SwiftUI

struct UserGoalView: View {
    @ObservedObject var userGoalViewModel: ObservableViewModel<UserGoalState, UserGoalAction>
    // @State var
    private var views: Dependency.Views

    init(
        userGoalViewModel: ObservableViewModel<UserGoalState, UserGoalAction>,
        views: Dependency.Views
    ) {
        self.userGoalViewModel = userGoalViewModel
        self.views = views
    }

    var body: some View {
        Text("Current goal: ")
    }
}

struct UserGoalView_Previews: PreviewProvider {
    static var previews: some View {
        UserGoalView(
            userGoalViewModel: ObservableViewModel(
                staticState: UserGoalState(currentGoalName: "Chipotle meal", currentGoalValue: 10.00)
            ),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
    }
}

extension Dependency.Views {
    var userGoalView: UserGoalView {
        return UserGoalView(
            userGoalViewModel: ObservableViewModel(viewModel: viewModels.userGoalViewModel),
            views: self
        )
    }
}
