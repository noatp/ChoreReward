//
//  ChoreTabNavBarContainer.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/22/22.
//

import SwiftUI

struct ChoreTabNavBarContainer<Content: View>: View {
    let pickerStateBinding: Binding<FinishedPickerState>
    let content: Content
    
    init(pickerStateBinding: Binding<FinishedPickerState>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.pickerStateBinding = pickerStateBinding
    }
    
    var body: some View {
        VStack(spacing: 0){
            ChoreTabNavBarView(pickerStateBinding: pickerStateBinding)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarHidden(true)
    }
}

struct ChoreTabNavBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        ChoreTabNavBarContainer(pickerStateBinding: .constant(.unfinished)) {
            Text("This is ChoreTabNavBarContainer")
        }
        .preferredColorScheme(.dark)
    }
}
