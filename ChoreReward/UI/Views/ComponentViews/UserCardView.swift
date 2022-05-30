//
//  UserCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI
import Kingfisher

struct UserCardView: View {
    private let user: User
    
    init(
        user: User
    ){
        self.user = user
    }
    
    var body: some View {
        HStack{
//            Group{
//                if let userImageUrl = user.profileImageUrl {
//                    RemoteImageView(
//                        imageUrl: userImageUrl,
//                        size: .init(width: 50, height: 50),
//                        cachingSize: .init(width: 50, height: 50)
//                    )
//                }
//                else{
//                    ImageView(systemImage: "person.fill", size: .init(width: 50, height: 50))
//                }
//            }
//            .clipShape(Circle())
//            .shadow(radius: 5)
//            .overlay(Circle().stroke(Color.fg, lineWidth: 0.5))
//            .padding(.trailing)
            
            Text(user.name)
                .font(.headline)
            Spacer()
            Text(user.role.rawValue)
                .font(.caption)
        }
        .padding()
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(user: User.preview)
            .previewLayout(.sizeThatFits)
    }
}

