//
//  ChoreCard.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/27/21.
//

import SwiftUI

struct ChoreCard: View {
    private var chore: Chore
    
    init(chore: Chore) {
        self.chore = chore
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Image(chore.finished ? chore.choreAfter : chore.choreBefore)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
            Text(chore.title)
                .font(.title)
            Text(chore.finished ?
                 "Finished by \(chore.whoTookThis)"
                 : "\(chore.whoCanTakeThis) can take this task")
                .font(.body)
            Text("Reward: \(chore.reward.amount) \(chore.reward.unit)")
                .font(.body)
        }
        .padding()
    }
}

struct ChoreCard_Previews: PreviewProvider {
    static var previews: some View {
        ChoreCard(chore: Chore.previewUnfinished)
            .previewLayout(.sizeThatFits)
        ChoreCard(chore: Chore.previewFinished)
            .previewLayout(.sizeThatFits)
    }
}
