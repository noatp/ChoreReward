//
//  RemoteImageView.swift
//  ChoreReward
//
//  Created by Toan Pham on 5/21/22.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: Main Implementaion

struct RemoteImage: View {
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
        Group {
            if let url = URL(string: imageUrl) {
                if isThumbnail {
                    WebImage(url: url)
                        .resizable()
                        .cancelOnDisappear(true)
                        .placeholder(content: {
                            ProgressView()
                        })
                        .transition(.fade(duration: 0.5))
                        .scaledToFill()
                } else {
                    WebImage(url: url)
                        .resizable()
                        .cancelOnDisappear(true)
                        .placeholder(content: {
                            ProgressView()
                        })
                        .transition(.fade(duration: 0.5))
                        .scaledToFill()
                }
            } else {
                Image(systemName: "person")
            }
        }

    }
}

// MARK: Preview

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(imageUrl: "https://s3.amazonaws.com/brt.org/tim-cook.png", isThumbnail: false)
            .previewLayout(.sizeThatFits)
    }
}
