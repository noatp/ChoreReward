//
//  ChoreTabView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/6/21.
//

import SwiftUI

struct ChoreTabView: View {
    @ObservedObject var choreTabViewModel: ChoreTabViewModel
    private var views: Dependency.Views
    
    init(
        choreTabViewModel: ChoreTabViewModel,
        views: Dependency.Views
    ){
        self.choreTabViewModel = choreTabViewModel
        self.views = views
    }
    var body: some View {
        Text("Chore Tab View")
    }
}

struct ChoreTabView_Previews: PreviewProvider {
    static var previews: some View {
        Dependency.preview.views().choreTabView
    }
}

extension Dependency.Views{
    var choreTabView: ChoreTabView{
        return ChoreTabView(
            choreTabViewModel: viewModels.choreTabViewModel,
            views: self
        )
    }
}
