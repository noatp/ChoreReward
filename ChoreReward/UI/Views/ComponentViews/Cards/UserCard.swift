//
//  UserCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI

// MARK: Main Implementaion

struct UserCard: View {
    private let user: DenormUser

    init(
        user: DenormUser
    ) {
        self.user = user
    }

    var body: some View {
        HStack {
            Group {
                if let userImageUrl = user.userImageUrl {
                    RemoteImage(imageUrl: userImageUrl)
                } else {
                    RegularImage(systemImage: "person.fill")
                }
            }
            .frame(width: 100, height: 100, alignment: .center)
            .clipShape(Circle())
            .padding(.trailing)

            Text(user.name ?? "")
                .font(StylingFont.headline)
            Spacer()
        }
    }
}

// MARK: Preview

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCard(user: DenormUser.preview)
            .previewLayout(.sizeThatFits)
    }
}
