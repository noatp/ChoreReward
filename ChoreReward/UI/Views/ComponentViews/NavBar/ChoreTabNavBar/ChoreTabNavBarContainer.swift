//
//  ChoreTabNavBarContainer.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/22/22.
//

import SwiftUI

struct ChoreTabNavBarContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .top){
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            ChoreTabNavBarView()
        }
        .navigationBarHidden(true)
    }
}

struct ChoreTabNavBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        ChoreTabNavBarContainer {
            Text("This is ChoreTabNavBarContainer")
        }
        .preferredColorScheme(.dark)
    }
}
