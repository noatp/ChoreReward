//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI

// MARK: Main Implementaion

struct ChoreCard: View {
    private let chore: Chore

    init(chore: Chore) {
        self.chore = chore
    }

    var body: some View {
        HStack(spacing: 0) {
            RemoteImage(imageUrl: chore.choreImageUrl)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
            VStack(alignment: .leading) {
                HStack {
                    Text(chore.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    Spacer()
                    Text("$\(chore.rewardValue)")
                }
                .font(StylingFont.headline)

                Spacer()
                HStack {
                    Text("\(chore.created.stringDateDistanceFromNow) ago")
                    Spacer()
                    Group {
                        if chore.finished == nil {
                            Text(chore.assignee == nil ? "Available" : "In progress")
                                .foregroundColor(chore.assignee == nil ? .green : .accent)
                        } else {
                            Text("Finished")
                                .foregroundColor(.green)
                        }
                    }
                }
                .font(StylingFont.subhead)
                .smallVerticalPadding()
            }
            .smallHorizontalPadding()
        }
        .background {
            Color.bg
        }
        .foregroundColor(.fg)
        .frame(maxHeight: 100)
    }
}

// MARK: Preview

struct ChoreCardView_Previews: PreviewProvider {

    static var previews: some View {
        ChoreCard(chore: .previewChoreUnfinished)
            .previewDisplayName("Unfinished Chore")
            .previewLayout(.sizeThatFits)
        ChoreCard(chore: .previewUnassignedChore)
            .previewDisplayName("Unassigned Chore")
            .previewLayout(.sizeThatFits)
        ChoreCard(chore: .previewChoreFinished)
            .previewDisplayName("Finished Chore")
            .previewLayout(.sizeThatFits)
    }
}
