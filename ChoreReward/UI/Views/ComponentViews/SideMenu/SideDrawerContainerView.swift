//
//  SideDrawerContainerView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/25/22.
//

import SwiftUI

struct SideDrawerContainerView<Content: View>: View {
    @Environment(\.presentingSideDrawer) @Binding var presentingSideDrawer: Bool
    let content: Content
    
    init(content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack{
            content
            if presentingSideDrawer{
                SideDrawerView()
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .scale))
            }
        }
        
    }
}

struct SideDrawerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SideDrawerContainerView{
                Text("This is SideDrawerContainerView")
        }
    }
}
