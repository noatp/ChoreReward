//
//  SideMenuView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/23/22.
//

import SwiftUI

struct SideDrawerView: View {
    @Environment(\.presentingSideDrawer) @Binding var presentingSideDrawer: Bool

    var body: some View {
        GeometryReader { geoProxy in
            HStack(spacing: 0){
                VStack{
                    Button {
                        withAnimation {
                            presentingSideDrawer = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundColor(.fg)
                    Spacer()
                }
                .padding(.horizontal)
                Divider()
                VStack(alignment: .leading){
                    Text("Family Chores")
                    Text("Your Chores")
                    Spacer()
                        .frame(maxWidth: .infinity)
                    Text("Settings")
                }
                .foregroundColor(.fg)
                .padding(.horizontal)
            }
            .frame(width: geoProxy.size.width * 0.75)
            .background(Color.bg2.ignoresSafeArea())
            .transition(.move(edge: .leading))
        }
        
    }
}

struct SideDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        SideDrawerView()
    }
}
