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
            print("\(#function): fail to compress image")
            return nil
        }
        
        do{
            let _ = try await imageRef.putDataAsync(imageData)
            return try await imageRef.downloadURL().absoluteString
        }
        catch{
            print("\(#function): \(error)")
            return nil
        }
    }
    
    func uploadChoreImage(image: UIImage, choreId: String) async -> String?{
        let imageRef = storage.reference().child("choreImage/\(choreId)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else{
            print("\(#function): fail to compress image")
            return nil
        }
        
        do{
            let _ = try await imageRef.putDataAsync(imageData)
            return try await imageRef.downloadURL().absoluteString
        }
        catch{
            print("\(#function): \(error)")
            return nil
        }
    }
}
