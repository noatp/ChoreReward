//
//  RemoteImageView.swift
//  ChoreReward
//
//  Created by Toan Pham on 5/21/22.
//

import SwiftUI
import Kingfisher
import SDWebImageSwiftUI

struct RemoteImageView: View {
    private let imageUrl: String
    private let isThumbnail: Bool

    init(
        imageUrl: String,
        isThumbnail: Bool
    ) {
        self.imageUrl = imageUrl
        self.isThumbnail = isThumbnail
    }

    var body: some View {
        if isThumbnail {
            WebImage(url: URL(string: imageUrl)!)
                .resizable()
                .cancelOnDisappear(true)
                .placeholder(content: {
                    ProgressView()
                })
                .transition(.fade(duration: 0.5))
                .scaledToFill()
        } else {
            WebImage(url: URL(string: imageUrl)!)
                .resizable()
                .cancelOnDisappear(true)
                .placeholder(content: {
                    ProgressView()
                })
                .transition(.fade(duration: 0.5))
                .scaledToFill()
        }

    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(imageUrl: "https://s3.amazonaws.com/brt.org/tim-cook.png", isThumbnail: false)
    }
}
