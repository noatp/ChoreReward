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
    let storage = Storage.storage()

    func uploadUserImage(with url: String, _ completion: @escaping ((String) -> Void)) {
        guard let imageUrl = URL(string: url) else {
            print("\(#fileID) \(#function): could not convert imageUrl String to URL")
            return
        }
        let imageRef = storage.reference().child("userImage/\(UUID().uuidString)")

        do {
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5) else {
                print("\(#fileID) \(#function): fail to compress image")
                return
            }
            imageRef.putData(image, completion: { result in
                switch result {
                case .success:
                    imageRef.downloadURL { (url, error) in
                        guard let downloadURL = url?.absoluteString, error == nil else {
                            print("\(#fileID) \(#function): \(error!)")
                            return
                        }
                        completion(downloadURL)
                    }
                case .failure(let error):
                    print("\(#fileID) \(#function): \(error)")
                }
            })
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }

    }

    func uploadChoreImage(with url: String, _ completion: @escaping ((String) -> Void)) {
        guard let imageUrl = URL(string: url) else {
            print("\(#fileID) \(#function): could not convert imageUrl String to URL")
            return
        }
        let imageRef = storage.reference().child("choreImage/\(UUID().uuidString)")

        do {
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5) else {
                print("\(#fileID) \(#function): fail to compress image")
                return
            }
            imageRef.putData(image, completion: { result in
                switch result {
                case .success:
                    imageRef.downloadURL { (url, error) in
                        guard let downloadURL = url?.absoluteString, error == nil else {
                            print("\(#fileID) \(#function): \(error!)")
                            return
                        }
                        completion(downloadURL)
                    }
                case .failure(let error):
                    print("\(#fileID) \(#function): \(error)")
                }
            })
        } catch {
            print("\(#fileID) \(#function): \(error)")
        }

    }
}
