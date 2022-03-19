//
//  ExecuteCodeView.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/19/22.
//

import SwiftUI

struct ExecuteCodeView: View {
    
    init(_ action: () -> Void){
        action()
    }
    
    var body: some View {
        EmptyView()
    }
}

struct ExecuteCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ExecuteCodeView {}
    }
}
