//
//  ListChoreView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/26/21.
//

import SwiftUI

struct ListChoreView: View {
    
    var body: some View {
        VStack{
            List{
                ChoreCard(chore: Chore.preview)
                ChoreCard(chore: Chore.preview)
            }
        }
        .toolbar {
            Button(action: {}) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }
}

struct ListChoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListChoreView()

        }
    }
}
