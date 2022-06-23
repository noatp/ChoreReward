//
//  UserCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI
import Kingfisher

struct UserCardView: View {
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
                    RemoteImageView(imageUrl: userImageUrl, isThumbnail: true)
                } else {
                    ImageView(systemImage: "person.fill")
                }
            }
            .frame(width: 100, height: 100, alignment: .center)
            .clipShape(Circle())
            .padding(.trailing)

            Text(user.name ?? "")
                .font(.headline)

            Spacer()
        }
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(user: DenormUser.preview)
            .previewLayout(.sizeThatFits)
    }
}
