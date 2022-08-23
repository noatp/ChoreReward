//
//  TEst.swift
//  ChoreReward
//
//  Created by Toan Pham on 8/22/22.
//

import SwiftUI

struct TEst: View {
    var body: some View {
        VStack {
            HStack {
                VStack {
                    CustomizableRegularButton {
                        Text("FUCK")
                    } action: {

                    }
                    Color.accent
                        .frame(height: 3)
                }
                .background(Color.green)

                VStack {
                    Text("YouYOUYOUYOUYYOUYOU")
                }
                .background(Color.gray)
            }
            Spacer()
        }

    }
}

struct TEst_Previews: PreviewProvider {
    static var previews: some View {
        TEst()
    }
}
