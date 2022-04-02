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
            ZStack(alignment: .leading){
                Color.bg.opacity(0.2).ignoresSafeArea()
                    .onTapGesture {
                        presentingSideDrawer = false
                    }
                HStack(spacing: 0){
                    VStack{
                        Button {
                            presentingSideDrawer = false
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .foregroundColor(.fg)
                        Spacer()
                    }
                    .padding(.horizontal)
                    Divider()
                    VStack(alignment: .leading){
                        Button {
                            presentingSideDrawer = false
                        } label: {
                            HStack{
                                Image(systemName: "person.3")
                                    .frame(width: 40, height: 40)
                                Text("Family Chores")
                            }
                        }
                        
                        Button {
                            presentingSideDrawer = false
                        } label: {
                            HStack{
                                Image(systemName: "person")
                                    .frame(width: 40, height: 40)
                                Text("Your Chores")
                            }
                        }

                        
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                        Button {
                            presentingSideDrawer = false
                        } label: {
                            HStack{
                                Image(systemName: "gearshape")
                                    .frame(width: 40, height: 40)
                                Text("Settings")
                            }
                        }
                    }
                    .foregroundColor(.fg)
                    .padding(.horizontal)
                }
                .frame(width: geoProxy.size.width * 0.75)
                .background(Color.bg2.ignoresSafeArea())
            }
            
        }
        
    }
}

struct SideDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        SideDrawerView()
    }
}
