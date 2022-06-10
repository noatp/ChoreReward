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

    func uploadUserProfileImage(imageUrl: String) async -> String? {
        guard let imageUrl = URL(string: imageUrl) else {
            print("\(#fileID) \(#function): could not convert imageUrl String to URL")
            return nil
        }
        let imageRef = storage.reference().child("userImage/\(UUID().uuidString)")

        do {
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5) else {
                print("\(#fileID) \(#function): fail to compress image")
                return nil
            }
            try await _ = imageRef.putDataAsync(image)
            return try await imageRef.downloadURL().absoluteString
        } catch {
            print("\(#fileID) \(#function): \(error)")
            return nil
        }

    }

    func uploadChoreImage(imageUrl: String, choreId: String) async -> String? {
        guard let imageUrl = URL(string: imageUrl) else {
            print("\(#fileID) \(#function): could not convert imageUrl String to URL")
            return nil
        }
        let imageRef = storage.reference().child("userImage/\(UUID().uuidString)")

        do {
            let imageData = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5) else {
                print("\(#fileID) \(#function): fail to compress image")
                return nil
            }
            try await _ = imageRef.putDataAsync(image)
            return try await imageRef.downloadURL().absoluteString
        } catch {
            print("\(#fileID) \(#function): \(error)")
            return nil
        }
    }
}
