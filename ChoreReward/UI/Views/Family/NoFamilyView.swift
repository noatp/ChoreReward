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
                Text("Please ask your family's admin to invite you to the family using the following QR code")
                    .multilineTextAlignment(.center)
                Image(uiImage: generateQRImage(from: viewState.currentUserId))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Text(viewState.currentUserId)
                if viewState.shouldRenderCreateFamilyButton {
                    Button("Create a new family") {
                        noFamilyViewModel.perform(action: .createFamily)
                    }
                }
                Spacer()
            }
            .padding()
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
            noFamilyViewModel: .init(
                staticState: .init(
                    shouldRenderCreateFamilyButton: true,
                    currentUserId: "preview userId"
                )
            ),
            views: Dependency.preview.views()
        )
        .previewLayout(.sizeThatFits)
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
