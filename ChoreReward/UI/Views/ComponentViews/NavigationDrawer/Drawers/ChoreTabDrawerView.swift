//
//  ChoreTabDrawerView.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/4/22.
//

import SwiftUI

struct ChoreTabDrawerView: View {
    var body: some View {
//        VStack(alignment: .leading){
//            Button {
//            } label: {
//                HStack{
//                    Image(systemName: "person.3")
//                        .frame(width: 40, height: 40)
//                    Text("Family Chores")
//                }
//            }
//
//            Button {
//            } label: {
//                HStack{
//                    Image(systemName: "person")
//                        .frame(width: 40, height: 40)
//                    Text("Your Chores")
//                }
//            }
//        }
        VStack(alignment: .leading){
            Spacer()
                .frame(maxWidth: .infinity)
        }
    }
}

struct ChoreTabDrawerView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreTabDrawerView()
            .previewLayout(.sizeThatFits)
    }
}
