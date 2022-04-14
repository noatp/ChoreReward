//
//  RootView.swift
//  ChoreReward
//
//  Created by Toan Pham on 11/28/21.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootViewModel: ObservableViewModel<RootViewState, Void>
    @State var presentingProgress: Bool = true
    
    private var views: Dependency.Views
    
    init(
        rootViewModel: ObservableViewModel<RootViewState, Void>,
        views: Dependency.Views
    ) {
        self.views = views
        self.rootViewModel = rootViewModel
    }
    
    var body: some View {
        ZStack{
            if rootViewModel.state.shouldRenderLoginView{
                views.loginView
            }
            else{
                views.appView
                    .onAppear {
                        presentingProgress = false
                    }
            }
            if presentingProgress{
                VStack{
                    Spacer()
                    ProgressView()
                        .shadow(color: Color(red: 0, green: 0, blue: 0.6),
                                            radius: 4.0, x: 1.0, y: 2.0)
                        .frame(maxWidth: .infinity)
                        
                    Spacer()
                }
                .background(Color.bg.opacity(0.7))
            }
        }
        .environment(\.presentingProgressView, $presentingProgress)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(
            rootViewModel: .init(
                staticState: .init(
                    shouldRenderLoginView: true
                )
            ),
            views: Dependency.preview.views()
        )
        RootView(
            rootViewModel: .init(
                staticState: .init(
                    shouldRenderLoginView: false
                )
            ),
            views: Dependency.preview.views()
        )
    }
}

extension Dependency.Views{
    var rootView: RootView{
        return RootView(
            rootViewModel: ObservableViewModel(viewModel: viewModels.rootViewModel),
            views: self
        )
    }
}
