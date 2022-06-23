//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI
import Kingfisher

struct `ChoreCardView`: View {
    private let chore: Chore

    init(chore: Chore) {
        self.chore = chore
    }

    var body: some View {
        HStack {
            RemoteImageView(imageUrl: chore.choreImageUrl, isThumbnail: true)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
            VStack(alignment: .leading) {
                HStack {
                    Text(chore.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.headline.weight(.semibold))
                    Spacer()
                    Text(chore.created.dateTimestamp.formatted(date: .numeric, time: .omitted))
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
                         created: Date().intTimestamp,
                         description: """
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididun
                            ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation
                            ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
                            reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur
                            sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id
                            est laborum.
                        """,
                         choreImageUrl: """
                            https://i2.wp.com/www.additudemag.com/wp-content/uploads/2016/12/Parent.Organize.Help_for
                            _messy_children_with_ADHD_end_chore_wars.Article.8863D.writing_list_on_blackboard.ts_4678
                            21785.jpg?resize=1280%2C720px&ssl=1
                        """
                        ))
            .previewLayout(.sizeThatFits)
    }
}
