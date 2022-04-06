//
//  NavBarView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/18/22.
//

import Foundation
import SwiftUI

struct ChoreDetailNavBarView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    private let navTitle: String
    private let opacity: Double
    private let content: Content
    
    init(navTitle: String, opacity: Double, content: () -> Content) {
        self.navTitle = navTitle
        self.opacity = opacity
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .top){
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack{
                NavBarButton
                Spacer()
            }
            .background(
                HStack{
                    Spacer(minLength: 50)
                    Text(navTitle)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .font(.title2)
                        .opacity(opacity)
                    Spacer(minLength: 50)
                }
            )
            .padding(.horizontal)
            .foregroundColor(.fg)
            .background(Color.bg.ignoresSafeArea(edges: .top).opacity(opacity))
        }
        .navigationBarHidden(true)
    }
}

struct ChoreDetailNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreDetailNavBarView(
            navTitle: "ChoreDetailNavBarView",
            opacity: 0.5) {
                Text("This is ChoreDetailNavBarView")
            }
    }
}

extension ChoreDetailNavBarView{
    private var NavBarButton: some View{
        CircularButton(action: {
            dismiss()
        }, icon: "xmark")
    }
}
