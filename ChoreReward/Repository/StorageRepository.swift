//
//  StorageRepository.swift
//  ChoreReward
//
//  Created by Toan Pham on 4/8/22.
//

import Foundation
import FirebaseStorage
import FirebaseStorageSwift
import UIKit

class StorageRepository {
    enum ImageType: String {
        case user = "userImage"
        case chore = "choreImage"
    }

    let storage = Storage.storage()

    func uploadImage(
        withUrl url: String,
        imageType: ImageType,
        _ completion: @escaping ((_ downloadURL: String, _ imagePath: String) -> Void)
    ) {
        guard let imageUrl = URL(string: url) else {
            print("\(#fileID) \(#function): could not convert imageUrl String to URL")
            return
        }

        let imageRef: StorageReference = storage.reference().child("\(imageType)/\(UUID().uuidString)")

        do {
            let imageData = try Data(contentsOf: imageUrl)
            guard let compressedImageData = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5) else {
                print("\(#fileID) \(#function): fail to compress image")
                return
            }

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            imageRef.putData(compressedImageData, metadata: metadata) { _, error in
                if let error = error {
                    print("\(#fileID) \(#function): \(error)")
                    return
                } else {
                    imageRef.downloadURL { (url, error) in
                        guard let downloadURL = url?.absoluteString, error == nil else {
                            print("\(#fileID) \(#function): \(error?.localizedDescription ?? "gettin absoluteString of URL failed")")
                            return
                        }
                        completion(downloadURL, imageRef.fullPath)
                    }
                }
            }
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }
    }

    func deleteImage(withPath path: String) {
        let imageRef = storage.reference(withPath: path)
        imageRef.delete { error in
            if let error = error {
                print("\(#fileID) \(#function): \(error)")
            } else {
                print("\(#fileID) \(#function): successfully delete image at \(path)")
            }
        }
    }
}
