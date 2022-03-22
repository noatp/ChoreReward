//
//  ChoreTabNavBar.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/22/22.
//

import SwiftUI

struct ChoreTabNavBarView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Chore")
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.title2)
            HStack{
                
            }

        }
    }
}

struct ChoreTabNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top){
            Text("This is NavBarView")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray)
            ChoreTabNavBarView()
        }
    }
}
