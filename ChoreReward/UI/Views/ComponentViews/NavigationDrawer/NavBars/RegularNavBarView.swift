//
//  RegularNavBarView.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/5/22.
//

import SwiftUI

struct RegularNavBarView<Content: View>: View {
    private let navTitle: String
    private let content: Content
    
    init(navTitle: String, content: () -> Content) {
        self.navTitle = navTitle
        self.content = content()
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer(minLength: 0)
                Text(navTitle)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.title2)
                    .foregroundColor(.fg)
                Spacer()
            }
            .padding([.leading, .bottom])
            .background(Color.bg.ignoresSafeArea(edges: .top))
            
            content
            Spacer(minLength: 0)
        }
        
    }
}

struct RegularNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        RegularNavBarView(navTitle: "RegularNavBarView") {
            VStack{
                Text("This is RegularNavBarView")
            }
        }
    }
}
