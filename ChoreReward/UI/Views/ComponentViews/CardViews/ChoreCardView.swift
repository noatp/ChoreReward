//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI

// MARK: Main Implementaion

struct `ChoreCardView`: View {
    @Environment(\.colorScheme) private var colorScheme
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
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(StylingFont.large)
                    Spacer()
                    Text(chore.created.dateTimestamp.formatted(date: .numeric, time: .omitted))
                        .font(StylingFont.small)
                }
                Text(chore.description)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .truncationMode(.tail)
                Spacer(minLength: 0)
            }
            .padding([.horizontal], 5)
        }
        .background {
            colorScheme == .light ?
            Color.white.shadow(color: .accDark, radius: 3, x: 0, y: 0)
            : Color.black.shadow(color: .accDark, radius: 3, x: 0, y: 0)
        }
        .foregroundColor(.fg2)
        .frame(maxHeight: 100)
        .padding([.bottom], 10)
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
