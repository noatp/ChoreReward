//
//  SideMenuView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/23/22.
//

import SwiftUI

struct SideDrawerView<Content: View>: View {
    @State var presentingSideDrawer: Bool = false
    
    let content: Content
    
    init(content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    Button {
                        withAnimation {
                            presentingSideDrawer = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                    .foregroundColor(.fg)

                    Text("Chore")
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.title)
                        .foregroundColor(.fg)
                    Spacer()
                }
                .padding([.leading, .bottom])
                .background(Color.bg.ignoresSafeArea(edges: .top))

                content
            }
            if (presentingSideDrawer){
                GeometryReader { geoProxy in
                    ZStack(alignment: .leading){
                        Color.bg.opacity(0.2).ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    presentingSideDrawer = false
                                }
                            }
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
                .transition(.move(edge: .leading))
            }
           
        }
        
        
    }
}

struct SideDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        SideDrawerView {
            Text("This is a preview")
        }
    }
}
