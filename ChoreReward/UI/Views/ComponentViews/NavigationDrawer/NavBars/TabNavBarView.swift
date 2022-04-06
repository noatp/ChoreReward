//
//  TabNavBarView.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/4/22.
//

import SwiftUI

struct TabNavBarView: View {
    @Binding var presentingSideDrawer: Bool
    
    private let navTitle: String
    
    init(presentingSideDrawer: Binding<Bool>, navTitle: String) {
        self._presentingSideDrawer = presentingSideDrawer
        self.navTitle = navTitle
    }
    
    var body: some View {
        HStack{
            Button {
                withAnimation {
                    presentingSideDrawer = true
                }
            } label: {
                Image(systemName: "line.3.horizontal")
            }
            .foregroundColor(.fg)

            Text(navTitle)
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.title)
                .foregroundColor(.fg)
            Spacer()
        }
        .padding([.leading, .bottom])
        .background(Color.bg.ignoresSafeArea(edges: .top))
    }
}

struct TabNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavBarView(presentingSideDrawer: .constant(false), navTitle: "Preview")
            .previewLayout(.sizeThatFits)
    }
}
