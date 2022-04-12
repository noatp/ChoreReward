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
    
    func uploadUserProfileImage(image: UIImage, userId: String) async -> String?{
        let imageRef = storage.reference().child("userImage/\(userId)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else{
            print("StorageRepository: uploadUserProfileImage: fail to compress image")
            return nil
        }
        
        do{
            let _ = try await imageRef.putDataAsync(imageData)
            let url = try await imageRef.downloadURL().absoluteString
            return url
        }
        catch{
            print("StorageRepository: uploadUserProfileImage: \(error)")
            return nil
        }
    }
    
    func updateUserProfileImage(newImage: UIImage, oldImageUrl: String?, userId: String) async -> String?{
        if let oldImageUrl = oldImageUrl {
            let oldImageRef = storage.reference(forURL: oldImageUrl)
            
            do{
                try await oldImageRef.delete()
            }
            catch{
                print("\(#function): \(error)")
            }
        }

        return await uploadUserProfileImage(image: newImage, userId: userId)
    }
}
