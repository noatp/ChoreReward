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
            
            VStack(alignment: .leading){
                HStack{
                    Text(chore.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Text(chore.created.formatted(date: .numeric, time: .omitted))
                        .font(.caption.weight(.thin))
                }
                Text(chore.description)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .truncationMode(.tail)
                    .font(.body.weight(.light))
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
                         description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                        ))
            .previewLayout(.sizeThatFits)
    }
}
