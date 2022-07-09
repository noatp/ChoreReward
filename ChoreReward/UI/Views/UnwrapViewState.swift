//
//  UnwrapViewState.swift
//  ChoreReward
//
//  Created by Toan Pham on 7/9/22.
//

import SwiftUI

struct UnwrapViewState <Content: View, ViewState>: View {
    private let viewState: ViewState?
    private let content: (ViewState) -> Content
    init(
        viewState: ViewState?,
        content: @escaping (_ viewState: ViewState) -> Content
    ) {
        self.viewState = viewState
        self.content = content
    }
    var body: some View {
        if let viewState = viewState {
            content(viewState)
        } else {
            ProgressView()
        }
    }
}

struct UnwrapViewState_Previews: PreviewProvider {
    static var previews: some View {
        UnwrapViewState(viewState: "nil") { _ in
            Text("preview")
        }
    }
}
