//
//  ChoreCardView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/21/22.
//

import SwiftUI

struct ChoreCardView: View {
    private let chore: Chore
    
    init(chore: Chore){
        self.chore = chore
    }
    
    var body: some View {
        HStack{
            Text(chore.title)
            Spacer()
            Text(chore.assignerId)
        }
        .frame(height: 50)
        .padding()
        .background(content: {
            RoundedRectangle(cornerRadius: 16)
                .stroke()
                .padding(2)
        })
    }
}

struct ChoreCardView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ChoreCardView(chore: Chore(id: "previewChore", title: "Preview Chore", assignerId: "123", assigneeId: "456"))
            .previewLayout(.sizeThatFits)
    }
}
