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
    var didFinishPickingMediaHandler: ((UIImage) -> Void)
    
    init(sourceType: UIImagePickerController.SourceType, didFinishPickingMediaHandler: @escaping ((UIImage) -> Void)) {
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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage{
                parent.didFinishPickingMediaHandler(uiImage)
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

//struct ContentView: View {
//    @State private var isPresented: Bool = false
//    var body: some View {
//        Button("Present Picker") {
//            isPresented.toggle()
//        }.sheet(isPresented: $isPresented) {
//            let configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
//            PhotoPicker(configuration: configuration, isPresented: $isPresented)
//        }
//    }
//}
//struct ImagePicker: UIViewControllerRepresentable {
//    let configuration: PHPickerConfiguration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
//    @Binding var isPresented: Bool
//    @Binding var image: UIImage?
//    @Binding var didChangeProfileImage: Bool
//
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        let controller = PHPickerViewController(configuration: configuration)
//        controller.delegate = context.coordinator
//        return controller
//    }
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: PHPickerViewControllerDelegate {
//
//        private let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
//                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] pickedImage, error in
//                    DispatchQueue.main.async {
//                        guard let pickedImage = pickedImage as? UIImage else {
//                            return
//                        }
//                        self?.parent.image = pickedImage
//                        self?.parent.didChangeProfileImage = true
//                    }
//                }
//            }
//            parent.isPresented = false
//
//        }
//    }
//}
