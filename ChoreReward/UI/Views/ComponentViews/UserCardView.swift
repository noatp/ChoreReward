//
//  UserCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/18/21.
//

import SwiftUI

struct UserCardView: View {
    private let user: User
    
    init(
        user: User
    ){
        self.user = user
    }
    
    var body: some View {
        HStack{
            Image("cook")
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 5)
                .overlay(Circle().stroke(Color.fg, lineWidth: 0.5))
                .padding(.trailing)
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

