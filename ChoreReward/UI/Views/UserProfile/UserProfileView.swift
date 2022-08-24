//
//  UserProfileView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

// MARK: Main Implementaion

struct UserProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var userProfileViewModel: ObservableViewModel<UserProfileState, UserProfileAction>
    private var views: Dependency.Views

    init(
        userProfileViewModel: ObservableViewModel<UserProfileState, UserProfileAction>,
        views: Dependency.Views
    ) {
        self.userProfileViewModel = userProfileViewModel
        self.views = views
    }

    var body: some View {
        UnwrapViewState(viewState: userProfileViewModel.viewState) { viewState in
            VStack(spacing: 16) {
                Group {
                    if let userImageUrl = viewState.currentUserProfileImageUrl {
                        RemoteImage(imageUrl: userImageUrl)
                    } else {
                        RegularImage(systemImage: "person.fill")
                    }
                }
                .frame(width: 200, height: 200, alignment: .center)
                .clipShape(Circle())
                Text(viewState.currentUserName)
                    .font(StylingFont.mediumTitle)

                HStack {
                    Text("Email:")
                        .font(StylingFont.headline)
                    Text(viewState.currentUserEmail)
                }
                HStack {
                    Text("Role:")
                        .font(StylingFont.headline)
                    Text(viewState.currentUserRole)
                }

                Spacer()

                NavigationLink {
                    views.editUserProfileView
                } label: {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit profile")
                    }
                }
                .font(StylingFont.headline)
                .foregroundColor(.fg)

                FilledButton(buttonTitle: "Log out", buttonImage: "arrow.backward.to.line") {
                    userProfileViewModel.perform(action: .signOut)
                }
            }
            .padding(StylingSize.largePadding)
            .vNavBar(NavigationBar(
                title: viewState.currentUserName,
                leftItem: backButton,
                rightItem: EmptyView()))
        }
    }
}

// MARK: Preview

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(
            userProfileViewModel: ObservableViewModel(staticState: .preview),
            views: Dependency.preview.views()
        )

        UserProfileView(
            userProfileViewModel: ObservableViewModel(staticState: .preview),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
    }
}

// MARK: Add to Dependency

extension Dependency.Views {
    var userProfileView: UserProfileView {
        return UserProfileView(
            userProfileViewModel: ObservableViewModel(viewModel: viewModels.userProfileViewModel),
            views: self
        )
    }
}

// MARK: Subviews

extension UserProfileView {
    var backButton: some View {
        CircularButton(action: {
            dismiss()
        }, icon: "chevron.left")
    }
}
