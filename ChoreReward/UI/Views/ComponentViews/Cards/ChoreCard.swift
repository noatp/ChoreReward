//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI

// MARK: Main Implementaion

struct ChoreCard: View {
    private let chore: DenormChore

    init(chore: DenormChore) {
        self.chore = chore
    }

    var body: some View {
        HStack(spacing: 0) {
            RemoteImage(imageUrl: chore.choreImageUrl, isThumbnail: true)
                .frame(width: 100, height: 100, alignment: .center)
                .clipped()
            VStack(alignment: .leading) {
                HStack {
                    Text(chore.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                    Spacer()

                    Text("$\(chore.value)")
                }
                .font(StylingFont.large)
                Spacer(minLength: 0)
                HStack {
                    Spacer()
                    Text(chore.assigneeId == nil ? "Available" : "In progress")
                        .foregroundColor(chore.assigneeId == nil ? .green : .accent)
                }

            }
            .smallHorizontalPadding()
            .smallVerticalPadding()
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
        ChoreCard(chore: .preview)
        .font(StylingFont.regular)
        .previewLayout(.sizeThatFits)
    }
}
