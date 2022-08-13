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
                Divider()
                Text(viewState.currentUserName)
                    .font(StylingFont.large)

                HStack {
                    Text("Email:")
                    Text(viewState.currentUserEmail)
                }
                HStack {
                    Text("Role:")
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

                FilledButton(buttonTitle: "Log out", buttonImage: "arrow.backward.to.line") {
                    userProfileViewModel.perform(action: .signOut)
                }
            }
            .padding()
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
        .font(StylingFont.regular)
        .previewLayout(.sizeThatFits)
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
        RegularButton(buttonImage: "chevron.left") {
            dismiss()
        }
    }
}
