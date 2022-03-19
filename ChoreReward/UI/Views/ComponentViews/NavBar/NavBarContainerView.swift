//
//  NavBarContainerView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/18/22.
//

import SwiftUI

struct NavBarContainerView<Content: View>: View {
    private var navBarTitle: String
    private var navBarOpacity: Double
    let content: Content
    
    init(navBarTitle: String, navBarOpacity: Double, @ViewBuilder content: () -> Content) {
        self.navBarTitle = navBarTitle
        self.navBarOpacity = navBarOpacity
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .top){
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            NavBarView(title: navBarTitle, opacity: navBarOpacity)
        }
        .navigationBarHidden(true)
    }
}

struct NavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NavBarContainerView(navBarTitle: "NavBarContainerView", navBarOpacity: 1) {
            Text("This is NavBarContainerView")
        }
    }
}
