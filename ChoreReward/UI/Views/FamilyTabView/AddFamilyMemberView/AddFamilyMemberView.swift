//
//  AddFamilyMemberView.swift
//  ChoreReward
//
//  Created by Toan Pham on 1/7/22.
//

import SwiftUI
import CodeScanner

struct AddFamilyMemberView: View {
    @ObservedObject var addFamilyMemberViewModel: ObservableViewModel<Void, AddFamilyMemberAction>
    @State var userIdInput = ""
    @Environment(\.dismiss) var dismiss
    private var views: Dependency.Views
    init(
        addFamilyMemberViewModel: ObservableViewModel<Void, AddFamilyMemberAction>,
        views: Dependency.Views
    ){
        self.addFamilyMemberViewModel = addFamilyMemberViewModel
        self.views = views
    }
    
    var body: some View {
        ZStack{
            Button {
                
            } label: {
                Text("TEST")
            }

        }
        VStack(spacing: 16){
            CodeScannerView(codeTypes: [.qr]) { result in
                handleScan(result: result)
            }
            ButtonView(buttonTitle: "Cancel", buttonImage: "xmark.app") {
                dismiss()
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let result):
            let userId = result.string
            dismiss()
            addFamilyMemberViewModel.perform(action: .addMember(userId: userId))
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

}

struct AddFamilyMemberView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AddFamilyMemberView(
                addFamilyMemberViewModel: ObservableViewModel(
                    staticState: ()
                ),
                views: Dependency.preview.views()
            )

        }
    }
}

extension Dependency.Views{
    func addFamilyMemberView() -> AddFamilyMemberView{
        return AddFamilyMemberView(
            addFamilyMemberViewModel: ObservableViewModel(
                viewModel: viewModels.addFamilyMemberViewModel
            ),
            views: self
        )
    }
}
