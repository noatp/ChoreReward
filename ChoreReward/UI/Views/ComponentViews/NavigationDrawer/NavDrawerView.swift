//
//  SideMenuView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/23/22.
//

import SwiftUI

struct NavDrawerView<Content: View>: View {
    @State var presentingSideDrawer: Bool = false
    
    private let content: Content
    private let navTitle: String
    
    init(navTitle: String, content: () -> Content) {
        self.navTitle = navTitle
        self.content = content()
    }

    var body: some View {
        ZStack{
            //main content: nav bar on top of content
            VStack(alignment: .leading, spacing: 0){
                TabNavBarView(presentingSideDrawer: $presentingSideDrawer, navTitle: navTitle)
                content
                Spacer(minLength: 0)
            }
            
            //side drawer content
            GeometryReader { geoProxy in
                ZStack(alignment: .leading){
                    //transparent layer to prevent interaction with main content
                    if (presentingSideDrawer){
                        Color.bg2.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    presentingSideDrawer = false
                                }
                            }
                            .transition(.opacity)

                        //side menu
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
                                Button {
                                } label: {
                                    HStack{
                                        Image(systemName: "person.3")
                                            .frame(width: 40, height: 40)
                                        Text("Family Chores")
                                    }
                                }
                                
                                Button {
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
                        .transition(.move(edge: .leading))
                    }
                    
                }
            }
        }
        
        
    }
}

struct SideDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        NavDrawerView(navTitle: "Preview") {
            Text("This is a preview")
        }
    }
}
