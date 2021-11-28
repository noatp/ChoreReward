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
            Text(chore.title)
                .font(.title)
            Text(chore.assignee.name + " finished this chore")
        }
        .padding()
    }
}

struct ChoreCard_Previews: PreviewProvider {
    static var previews: some View {
        ChoreCard(chore: Chore.preview)
            .previewLayout(.sizeThatFits)
    }
}
