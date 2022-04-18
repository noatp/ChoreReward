//
//  SideMenuView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/23/22.
//

import SwiftUI

struct NavDrawerView<MainContent: View, DrawerContent: View>: View {
    @State var presentingSideDrawer: Bool = false
    
    private var views: Dependency.Views
    private let mainContent: MainContent
    private let drawerContent: DrawerContent
    private let navTitle: String
    
    init(
        navTitle: String,
        views: Dependency.Views,
        mainContent: () -> MainContent,
        drawerContent: () -> DrawerContent
    ) {
        self.navTitle = navTitle
        self.mainContent = mainContent()
        self.drawerContent = drawerContent()
        self.views = views
    }

    var body: some View {
        ZStack{
            //main content: nav bar on top of content
            VStack(alignment: .leading, spacing: 0){
                TabNavBarView(presentingSideDrawer: $presentingSideDrawer, navTitle: navTitle)
                mainContent
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
                                drawerContent
                                Spacer()
                                    .frame(maxWidth: .infinity)
                                basicDrawerContent
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
        NavDrawerView(
            navTitle: "Preview",
            views: Dependency.preview.views()
        ){
            Text("This is a Preview of NavDrawerView")
        } drawerContent: {
            ChoreTabDrawerView()
        }
    }
}

extension Dependency.Views{
    func navDrawerView<MainContent: View, DrawerContent: View>(
        navTitle: String,
        mainContent: () -> MainContent,
        drawerContent: () -> DrawerContent
    ) -> NavDrawerView<MainContent, DrawerContent>{
        return NavDrawerView(
            navTitle: navTitle,
            views: self,
            mainContent: mainContent,
            drawerContent: drawerContent
        )
    }
}

extension NavDrawerView{
    var basicDrawerContent: some View {
        VStack(alignment: .leading){
            NavigationLink {
                views.userProfileView
            } label: {
                HStack{
                    Image(systemName: "person.crop.circle")
                        .frame(width: 40, height: 40)
                    Text("Your Profile")
                }
            }

            Button {
            } label: {
                HStack{
                    Image(systemName: "gearshape")
                        .frame(width: 40, height: 40)
                    Text("Settings")
                }
            }
        }
    }
}
