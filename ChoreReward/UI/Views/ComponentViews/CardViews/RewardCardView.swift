//
//  RewardCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 6/19/22.
//

import SwiftUI

struct RewardCardView: View {
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
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .padding(.bottom, 10)
                Spacer()
                Text(String(format: "$%.2f", rewardValue))
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .padding(.bottom, 10)
            }

            HStack {
                Group {
                    Text("Earned: ")
                    + Text(String(format: "$%.2f of ", userBalance))
                    + Text(String(format: "$%.2f", rewardValue))
                }
                .font(.system(size: 12, weight: .regular, design: .default))
                Spacer()
                Group {
                    Text(String(format: "%.0f", progress * 100))
                    + Text("%")
                }
                .font(.system(size: 12, weight: .regular, design: .default))
            }
            ProgressView(value: userBalance/rewardValue)
                .progressViewStyle(.linear)
                .shadow(color: Color(red: 0, green: 0, blue: 0.6),
                        radius: 4.0, x: 1.0, y: 2.0)
                .padding(.bottom, 10)
        }
        .padding()
    }
}

struct RewardCardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardCardView(rewardName: "Chipotle Meal", rewardValue: 10.50, userBalance: 5.00)
            .previewLayout(.sizeThatFits)
    }
}
