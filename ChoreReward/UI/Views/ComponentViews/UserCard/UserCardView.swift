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
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipped()
            Text(user.name)
            Spacer()
            Text(user.role.rawValue)
        }
        .padding()
        .background(content: {
            RoundedRectangle(cornerRadius: 32)
                .stroke(lineWidth: 2)
                .padding(2)
        })
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(user: User.previewTim)
            .previewLayout(.sizeThatFits)
    }
}

