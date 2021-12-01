//
//  UseCaseResult.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/30/21.
//

import Foundation

enum UseCaseResult<T>{
    case success(returnData: T?)
    case error(error: Error)
}
