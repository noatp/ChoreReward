//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI

// MARK: Main Implementaion

struct `ChoreCardView`: View {
    private let chore: Chore

    init(chore: Chore) {
        self.chore = chore
    }

    var body: some View {
        HStack(spacing: 0) {
            RemoteImageView(imageUrl: chore.choreImageUrl, isThumbnail: true)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
            VStack(alignment: .leading) {
                HStack {
                    Text(chore.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(0)
                    Spacer()
                    Text(chore.rewardValue != nil ? "$\(chore.rewardValue!)" : "$0")
                }
                .font(StylingFont.large)
                Text(chore.created.dateTimestamp.formatted(date: .numeric, time: .omitted))
                    .font(StylingFont.small)
            }
            .smallHorizontalPadding()
        }
        .background {
            Color.bg.shadow(color: .accentGraySecondary, radius: 3, x: 0, y: 0)
        }
        .foregroundColor(.fg)
        .frame(maxHeight: 100)
    }
}

// MARK: Preview

struct ChoreCardView_Previews: PreviewProvider {

    static var previews: some View {
        ChoreCardView(
            chore: Chore(id: "previewChoreID",
                         title: "Preview Chore",
                         assignerId: "123",
                         assigneeId: "456",
                         created: Date().intTimestamp,
                         description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do",
                         choreImageUrl: "https://s3.amazonaws.com/brt.org/tim-cook.png"
                        ))
        .font(StylingFont.regular)
        .previewLayout(.sizeThatFits)
    }
}
