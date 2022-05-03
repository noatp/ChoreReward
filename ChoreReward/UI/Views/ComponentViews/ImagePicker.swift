//
//  ImagePicker.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/3/22.
//

import Foundation
import SwiftUI

//enum ImageState{
//    case empty, local(uiImage: UIImage), remote(url: String)
//
//    var localImage: UIImage?{
//        switch self{
//        case .empty, .remote:
//            return nil
//        case .local(let uiImage):
//            return uiImage
//        }
//    }
//}

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var image: UIImage?
    @Binding var didChangeProfileImage: Bool

    private let controller = UIImagePickerController()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage{
                parent.image = uiImage
                parent.didChangeProfileImage = true
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }

    }

    func makeUIViewController(context: Context) -> some UIViewController {
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }

}
