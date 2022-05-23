//
//  RemoteImageView.swift
//  ChoreReward
//
//  Created by Toan Pham on 5/21/22.
//

import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    private let imageUrl: String
    private let size: CGSize
    
    init(
        imageUrl: String,
        size: CGSize
    ) {
        self.imageUrl = imageUrl
        self.size = size
    }
    
    var body: some View {
        let cache = ImageCache.default
        let processor = DownsamplingImageProcessor(size: .init(width: size.width * 3, height: size.height * 3))
                        
        var cachedPros = cache.isCached(forKey: imageUrl, processorIdentifier: processor.identifier)
        var cacheTypePros = cache.imageCachedType(forKey: imageUrl, processorIdentifier: processor.identifier)
        var cached = cache.isCached(forKey: imageUrl)
        var cacheType = cache.imageCachedType(forKey: imageUrl)
        
        
        print("\(#fileID) \(#function): before", imageUrl, cached, cacheType, processor.size, cachedPros, cacheTypePros)

        let image =  KFImage(URL(string: imageUrl))
            .cacheOriginalImage()
            .cache
            .placeholder({ProgressView()})
            .setProcessor(processor)
            .cancelOnDisappear(true)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
        
        cachedPros = cache.isCached(forKey: imageUrl, processorIdentifier: processor.identifier)
        cacheTypePros = cache.imageCachedType(forKey: imageUrl, processorIdentifier: processor.identifier)
        cached = cache.isCached(forKey: imageUrl)
        cacheType = cache.imageCachedType(forKey: imageUrl)
        
        print("\(#fileID) \(#function): after", imageUrl, cached, cacheType, processor.size, cachedPros, cacheTypePros)
        
        return image
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(
            imageUrl: "https://s3.amazonaws.com/brt.org/tim-cook.png",
            size: .init(width: 100, height: 100)
        )
    }
}
