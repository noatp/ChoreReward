//
//  ChoreTabNavBarContainer.swift
//  ChoreReward
//
//  Created by Toan Pham on 3/22/22.
//

import SwiftUI

struct ChoreTabNavBarContainerView<Content: View>: View {
    let pickerStateBinding: Binding<FinishedPickerState>
    let drawerStateBinding: Binding<Bool>
    let content: Content
    
    init(
        pickerStateBinding: Binding<FinishedPickerState>,
        drawerStateBinding: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.pickerStateBinding = pickerStateBinding
        self.drawerStateBinding = drawerStateBinding
    }
    
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                ChoreTabNavBarView(
                    pickerStateBinding: pickerStateBinding,
                    drawerStateBinding: drawerStateBinding
                )
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            if (drawerStateBinding.wrappedValue){
                SideMenuView(drawerStateBinding: drawerStateBinding)
                    .transition(.move(edge: .leading))
            }
        }
        .navigationBarHidden(true)
    }
}

struct ChoreTabNavBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ChoreTabNavBarContainerView(pickerStateBinding: .constant(.unfinished), drawerStateBinding: .constant(true)) {
            Text("This is ChoreTabNavBarContainer")
        }
        .preferredColorScheme(.dark)
    }
}
