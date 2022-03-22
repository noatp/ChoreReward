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
        VStack(spacing: 0){
            ChoreTabNavBarView()
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
