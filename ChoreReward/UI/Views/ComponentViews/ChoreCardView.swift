//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI
import Kingfisher

struct ChoreCardView: View {
    private let chore: Chore
    
    init(chore: Chore){
        self.chore = chore
    }
    
    var body: some View {
        HStack{
//            RemoteImageView(
//                imageUrl: chore.choreImageUrl,
//                size: .init(width: 100, height: 100),
//                cachingSize: .init(width: 100, height: 100)
//            )
//            .clipped()

            RemoteImageView(imageUrl: chore.choreImageUrl, isThumbnail: true)
            
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
        .foregroundColor(.fg2)
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
                         description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                         choreImageUrl: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fi2.wp.com%2Fwww.additudemag.com%2Fwp-content%2Fuploads%2F2016%2F12%2FParent.Organize.Help_for_messy_children_with_ADHD_end_chore_wars.Article.8863D.writing_list_on_blackboard.ts_467821785.jpg%3Fresize%3D1280%252C720px%26ssl%3D1&imgrefurl=https%3A%2F%2Fwww.additudemag.com%2Fchores-adhd-kids-advice%2F&tbnid=JoyY0F3TY2-B4M&vet=12ahUKEwj47vuwidv3AhUxAjQIHY8vBuEQMygPegUIARDhAg..i&docid=ibx8hno3uwc1CM&w=1280&h=720&q=chore%20image&ved=2ahUKEwj47vuwidv3AhUxAjQIHY8vBuEQMygPegUIARDhAg"
                        ))
            .previewLayout(.sizeThatFits)
    }
}
