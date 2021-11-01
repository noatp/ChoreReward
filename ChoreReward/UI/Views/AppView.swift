//
//  AppView.swift
//  ChoreReward
//
//  Created by Toan Pham on 10/31/21.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        NavigationView {
            VStack{
                List{
                    ChoreCard(chore: Chore.previewFinished)
                    ChoreCard(chore: Chore.previewUnfinished)
                }
            }
            .toolbar {
                Button(action: {}) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
