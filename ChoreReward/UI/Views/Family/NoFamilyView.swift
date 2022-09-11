//
//  NoFamilyView.swift
//  ChoreReward
//
//  Created by Toan Pham on 12/26/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
// import CoreImage

struct NoFamilyView: View {
    @ObservedObject var noFamilyViewModel: ObservableViewModel<NoFamilyState, NoFamilyAction>
    private var views: Dependency.Views

    init(
        noFamilyViewModel: ObservableViewModel<NoFamilyState, NoFamilyAction>,
        views: Dependency.Views
    ) {
        self.noFamilyViewModel = noFamilyViewModel
        self.views = views
    }

    var body: some View {
        UnwrapViewState(viewState: noFamilyViewModel.viewState) { viewState in
            VStack(spacing: 16) {
                Spacer()
                Text("Please ask your family's admin to invite you to the family by scanning QR code below")
                    .multilineTextAlignment(.center)
                Image(uiImage: generateQRImage(from: viewState.currentUserId))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                HStack(alignment: .center, spacing: .zero) {
                    VStack(alignment: .center, spacing: .zero) {
                        Divider()
                    }
                    Spacer()
                    Text("or")
                    Spacer()
                    VStack(alignment: .center, spacing: .zero) {
                        Divider()
                    }
                }
                if viewState.shouldRenderCreateFamilyButton {
                    FilledButton(buttonTitle: "Create a new family", buttonImage: "plus") {
                        noFamilyViewModel.perform(action: .createFamily)
                    }
                }
                Spacer()
                FilledButton(buttonTitle: "Log out", buttonImage: "arrow.backward.to.line") {
                    noFamilyViewModel.perform(action: .signOut)
                }
            }
            .padding(StylingSize.largePadding)
            .vNavBar(NavigationBar(title: "Let's get started", leftItem: EmptyView(), rightItem: EmptyView()))
            .progressViewContainer(shouldShowProgessView: viewState.shouldShowProgressView)
        }
    }

    private func generateQRImage(from userId: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(userId.utf8)

            if let outputImage = filter.outputImage {
                if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                    return UIImage(cgImage: cgimg)
                }
            }

            return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct NoFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        NoFamilyView(
            noFamilyViewModel: .init(staticState: .preview),
            views: Dependency.preview.views()
        )

        NoFamilyView(
            noFamilyViewModel: .init(staticState: .preview),
            views: Dependency.preview.views()
        )
        .preferredColorScheme(.dark)
    }
}

extension Dependency.Views {
    var noFamilyView: NoFamilyView {
        return NoFamilyView(
            noFamilyViewModel: ObservableViewModel(viewModel: viewModels.noFamilyViewModel),
            views: self
        )

    }
}
