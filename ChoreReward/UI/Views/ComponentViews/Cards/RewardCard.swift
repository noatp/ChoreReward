//
//  RewardCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/19/22.
//

import SwiftUI

// MARK: Main Implementaion

struct RewardCard: View {
    let rewardName: String
    let rewardValue: Int
    let userBalance: Int
    var progress: Int {
        userBalance * 100 / rewardValue
    }

    var body: some View {
        VStack {
            HStack {
                Text(rewardName)
                Spacer()
                Text("$\(rewardValue)")
            }
            .font(StylingFont.headline)

            HStack {
                Text("Earned: $\(userBalance) of $\(rewardValue)")
                Spacer()
                Text("\(progress)%")
            }
            .smallVerticalPadding()
            CustomProgressBar(progress: progress)
        }
        .padding(StylingSize.largePadding)
        .background {
            Color.bg
        }
        .padding([.bottom], StylingSize.mediumPadding)
    }
}

// MARK: Preview

struct RewardCardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardCard(rewardName: "Chipotle Meal", rewardValue: 10, userBalance: 5)
            .previewLayout(.sizeThatFits)
    }
}
