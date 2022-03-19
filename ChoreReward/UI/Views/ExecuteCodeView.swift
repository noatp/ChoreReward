//
//  ExecuteCodeView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/19/22.
//

import SwiftUI

struct ExecuteCode : View {
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        return EmptyView()
    }
}

struct ExecuteCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ExecuteCode{}
    }
}
