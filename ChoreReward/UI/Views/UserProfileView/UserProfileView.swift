//
//  UserProfileView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI
import Kingfisher

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
        VStack(spacing: 16) {
            Group {
                if let userImageUrl = userProfileViewModel.state.currentUserProfileImageUrl {
                    RemoteImageView(imageUrl: userImageUrl, isThumbnail: false)
                } else {
                    ImageView(systemImage: "person.fill")
                }
            }
            .frame(width: 200, height: 200, alignment: .center)
            .clipShape(Circle())
            Divider()
            Text(userProfileViewModel.state.currentUserName)
                .font(.title)

            HStack {
                Text("Email:")
                Text(userProfileViewModel.state.currentUserEmail)
            }
            HStack {
                Text("Role:")
                Text(userProfileViewModel.state.currentUserRole)
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

            ButtonView(buttonTitle: "Log out", buttonImage: "arrow.backward.to.line") {
                userProfileViewModel.perform(action: .signOut)
            }
        }
        .padding()
        .vNavBar(NavigationBar(
            title: userProfileViewModel.state.currentUserName,
            leftItem: backButton,
            rightItem: EmptyView()))
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(
            userProfileViewModel: ObservableViewModel(
                staticState: UserProfileState(
                    currentUserEmail: "toan.chpham@gmail.com",
                    currentUserName: "Toan Pham",
                    currentUserRole: "Child",
                    currentUserProfileImageUrl: nil
                )
            ),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
    }
}

extension Dependency.Views {
    var userProfileView: UserProfileView {
        return UserProfileView(
            userProfileViewModel: ObservableViewModel(viewModel: viewModels.userProfileViewModel),
            views: self
        )
    }
}

extension UserProfileView {
    var backButton: some View {
        ButtonView(buttonImage: "chevron.left") {
            dismiss()
        }
    }
}
