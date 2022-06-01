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
//    private let imageUrl: String
//    private let size: CGSize
//    private let cachingSize: CGSize
    private let imageUrl: String
    private let isThumbnail: Bool

    init(
//        imageUrl: String,
//        size: CGSize,
//        cachingSize: CGSize
        imageUrl: String,
        isThumbnail: Bool
    ) {
//        self.imageUrl = imageUrl
//        self.size = size
//        self.cachingSize = cachingSize
        self.imageUrl = imageUrl
        self.isThumbnail = isThumbnail
    }

    var body: some View {
//        let processor = DownsamplingImageProcessor(size: .init(width: cachingSize.width*3, height: cachingSize.height*3))
//        return KFImage(URL(string: imageUrl))
//            .placeholder({ProgressView()})
//            .setProcessor(processor)
//            .cancelOnDisappear(true)
//            .resizable()
//            .scaledToFill()
//            .frame(width: size.width, height: size.height)
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
//        RemoteImageView(
//            imageUrl: "https://s3.amazonaws.com/brt.org/tim-cook.png",
//            size: .init(width: 100, height: 100),
//            cachingSize: .init(width: 100, height: 100)
//        )
        RemoteImageView(imageUrl: "https://s3.amazonaws.com/brt.org/tim-cook.png", isThumbnail: false)
    }
}
