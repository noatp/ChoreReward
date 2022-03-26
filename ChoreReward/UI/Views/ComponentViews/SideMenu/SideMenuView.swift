//
//  SideMenuView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/23/22.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var drawerStateBinding: Bool
    
    var body: some View {
        GeometryReader { geoProxy in
            HStack(spacing: 0){
                VStack{
                    CircularButton(action: {
                        withAnimation {
                            drawerStateBinding = false
                        }
                    }, icon: "xmark")
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

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(drawerStateBinding: .constant(true))
            .preferredColorScheme(.dark)
        
        SideMenuView(drawerStateBinding: .constant(false))
    }
}
