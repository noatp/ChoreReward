//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI

struct ChoreCardView: View {
    private let chore: Chore
    
    init(chore: Chore){
        self.chore = chore
    }
    
    var body: some View {
        HStack{
            Image("unfinishedDishes")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
            
            VStack{
                Text(chore.title)
                Text(chore.id ?? "")
            }
            Spacer()
        }
        .foregroundColor(.fg)
    }
}

struct ChoreCardView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ChoreCardView(
            chore: Chore(id: "previewChoreID",
                         title: "Preview Chore",
                         assignerId: "123",
                         assigneeId: "456",
                         created: Date(),
                         description: ""
                        ))
            .previewLayout(.sizeThatFits)
    }
}
