//
//  DeepLinkService.swift
//  ChoreReward
//
//  Created by Toan Pham on 8/9/22.
//

import Foundation

class DeepLinkService {
    class DeepLinkConstants {
        static let scheme = "chorereward"
        static let host = "com.noatp.chorereward"
    }

    func parseUrlToDeepLinkTarget(_ url: URL) -> DeepLinkTarget {
        guard url.scheme == DeepLinkConstants.scheme,
              url.host == DeepLinkConstants.host
        else {
            return .none
        }

        switch url.path {
        case "/detail":
            guard let choreId = url.query else {
                return .none
            }
            return .detail(choreId: choreId)
        case "/addMember":
            return .addMember
        default:
            return .none
        }
    }
}

enum DeepLinkTarget {
    case detail(choreId: String)
    case addMember
    case none
}
