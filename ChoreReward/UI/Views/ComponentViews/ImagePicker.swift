//
//  ImagePicker.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/3/22.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    var sourceType: UIImagePickerController.SourceType
    var didFinishPickingMediaHandler: ((String) -> Void)

    init(sourceType: UIImagePickerController.SourceType, didFinishPickingMediaHandler: @escaping ((String) -> Void)) {
        self.sourceType = sourceType
        self.didFinishPickingMediaHandler = didFinishPickingMediaHandler
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let imageUrl = info[.imageURL] as? URL {
                parent.didFinishPickingMediaHandler(imageUrl.absoluteString)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        controller.sourceType = sourceType
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

}
