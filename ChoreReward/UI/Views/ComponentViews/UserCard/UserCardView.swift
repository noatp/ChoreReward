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
        VStack{
            HStack{
                Text(user.name)
                Spacer()
                Text(user.role.rawValue)
            }
        }
        .padding()
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(user: User.previewTim)
            .previewLayout(.sizeThatFits)
    }
}

