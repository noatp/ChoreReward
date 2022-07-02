//
//  ImageView.swift
//  ChoreReward
//
//  Created by Toan Pham on 5/22/22.
//

import SwiftUI

struct RegularImage: View {
    let systemImage: String?
    let uiImage: UIImage?

    init(
        systemImage: String? = nil,
        uiImage: UIImage? = nil
    ) {
        self.systemImage = systemImage
        self.uiImage = uiImage
    }

    var body: some View {
        Group {
            if let systemImage = systemImage {
                Image(systemName: systemImage).resizable()
            } else if let uiImage = uiImage {
                Image(uiImage: uiImage).resizable()
            } else {
                Image(systemName: "person.fill").resizable()
            }
        }
        .scaledToFill()
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        RegularImage(systemImage: "person")
    }
}
