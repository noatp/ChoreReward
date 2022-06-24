//
//  RewardCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/19/22.
//

import SwiftUI

// MARK: Main Implementaion

struct RewardCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    let rewardName: String
    let rewardValue: Float
    let userBalance: Float
    var progress: Float {
        userBalance / rewardValue
    }

    var body: some View {
        VStack {
            HStack {
                Text(rewardName)
                Spacer()
                Text(String(format: "$%.2f", rewardValue))
            }
            .font(StylingFont.large)
            .smallVerticalPadding()

            HStack {
                Group {
                    Text("Earned: ")
                    + Text(String(format: "$%.2f of ", userBalance))
                    + Text(String(format: "$%.2f", rewardValue))
                }
                Spacer()
                Group {
                    Text(String(format: "%.0f", progress * 100))
                    + Text("%")
                }
            }
            .font(StylingFont.small)
            .smallVerticalPadding()
            ProgressView(value: userBalance/rewardValue)
                .progressViewStyle(.linear)
                .shadow(color: Color(red: 0, green: 0, blue: 0.6),
                        radius: 4.0, x: 1.0, y: 2.0)
                .padding(.bottom, 10)
        }
        .padding()
        .background {
            colorScheme == .light ?
            Color.white.shadow(color: .accDark, radius: 3, x: 0, y: 0)
            : Color.black.shadow(color: .accDark, radius: 3, x: 0, y: 0)
        }
        .padding([.bottom], 10)
    }
}

// MARK: Preview

struct RewardCardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardCardView(rewardName: "Chipotle Meal", rewardValue: 10.50, userBalance: 5.00)
            .font(StylingFont.regular)
            .previewLayout(.sizeThatFits)
    }
}
