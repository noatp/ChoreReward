//
//  ImageView.swift
//  ChoreReward
//
//  Created by Toan Pham on 5/22/22.
//

import SwiftUI

struct ImageView: View {
    let systemImage: String?
    let uiImage: UIImage?
    let size: CGSize
    
    init(
        systemImage: String? = nil,
        uiImage: UIImage? = nil,
        size: CGSize
    ) {
        self.systemImage = systemImage
        self.uiImage = uiImage
        self.size = size
    }
    
    var body: some View {
        Group{
            if let systemImage = systemImage {
                Image(systemName: systemImage).resizable()
            }
            else if let uiImage = uiImage {
                Image(uiImage: uiImage).resizable()
            }
            else{
                Image(systemName: "person.fill").resizable()
            }
        }
        .scaledToFill()
        .frame(width: size.width, height: size.height)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(systemImage: "person", size: .init(width: 200, height: 200))
    }
}
