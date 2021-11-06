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
            
            whoIsOnTheTask
            
            Text("Reward: \(chore.reward.amount)") + rewardUnitText
                .font(.body)
            
        }
        .padding()
    }
    
    var whoIsOnTheTask: some View{
        var whoCanTakeThisTaskString = ""
        if (chore.finished){
            return Text(chore.whoTookThis!.nickname + " finished this chore")
        }
        else{
            for (index, person) in chore.whoCanTakeThis.enumerated(){
                if (index == chore.whoCanTakeThis.count - 1){
                    whoCanTakeThisTaskString = whoCanTakeThisTaskString + person.nickname + " can take this chore"
                }
                else{
                    whoCanTakeThisTaskString = whoCanTakeThisTaskString + person.nickname + ", "
                }
            }
            return Text(whoCanTakeThisTaskString)
        }
    }
    
    var rewardUnitText: Text{
        switch(chore.reward.unit){
            case rewardUnit.percentOfCurrentGoal:
                return Text(" percent of current goal")
            case rewardUnit.dollar:
                return Text(" dollar")
        }
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
