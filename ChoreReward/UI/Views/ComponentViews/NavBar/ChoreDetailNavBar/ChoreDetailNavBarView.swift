//
//  NavBarView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/18/22.
//

import Foundation
import SwiftUI

struct ChoreDetailNavBarView: View {
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

struct ChoreDetailNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top){
            Text("This is NavBarView")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray)
            ChoreDetailNavBarView(title: "NavBarViewWithAVeryVeryLongname", opacity: 1)
        }
    }
}

extension ChoreDetailNavBarView{
    private var NavBarButton: some View{
        CircularButton(action: {
            presentationMode.wrappedValue.dismiss()
        }, icon: "xmark")
    }
}
