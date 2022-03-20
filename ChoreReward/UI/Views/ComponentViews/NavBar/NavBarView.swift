//
//  NavBarView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/18/22.
//

import Foundation
import SwiftUI

struct NavBarView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let title: String
    let opacity: Double
    
    init(title: String, opacity: Double) {
        self.title = title
        self.opacity = opacity
    }
    
    var body: some View {
        HStack{
            NavBarButton
            Spacer()
            NavBarButton
            .opacity(0)
        }
        .background(
            HStack{
                Spacer(minLength: 50)
                Text(title)
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
}

struct NavBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top){
            Text("This is NavBarView")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray)
            NavBarView(title: "NavBarViewWithAVeryVeryLongname", opacity: 1)
        }
    }
}

extension NavBarView{
    private var NavBarButton: some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .frame(width: 40, height: 40)
                .foregroundColor(Color.fg)
                .background(Color.bg)
                .clipShape(Circle())
        }
    }
}
