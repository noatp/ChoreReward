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

class StorageRepository{
    let storage = Storage.storage()
    
    func uploadUserProfileImage(image: UIImage, userId: String) async -> String{
        let imageRef = storage.reference().child("userImage/\(userId)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else{
            print("StorageRepository: uploadUserProfileImage: fail to compress image")
            return ""
        }
        
        do{
            let _ = try await imageRef.putDataAsync(imageData)
            let url = try await imageRef.downloadURL().absoluteString
            return url
        }
        catch{
            print("StorageRepository: uploadUserProfileImage: \(error)")
            return ""
        }
    }
    
    func downloadUserProfileImage(imageUrl: String) async -> UIImage?{
        let imageRef = storage.reference(forURL: imageUrl)
        
        do {
            let imageData = try await imageRef.data(maxSize: 5 * 1024 * 1024)
            return UIImage(data: imageData)
        }
        catch{
            print("StorageRepository: downLoadUserProfileImage: \(error)")
            return nil
        }
    }
}
