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
    
    func uploadUserProfileImage(image: UIImage, userId: String, completion: @escaping (_ url: String) -> Void){
        print("start uploading image here")
        let imageRef = storage.reference().child("userImage/\(userId)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else{
            print("StorageRepository: uploadUserProfileImage: fail to compress image")
            return
        }
        
        imageRef.putData(imageData, metadata: nil) { storageMetadata, error in
            if let error = error {
                print("\(#function): \(error)")
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("\(#function): \(error)")
                    return
                }
                
                guard let url = url else{
                    print("\(#function): failed to get url")
                    return
                }
                completion(url.absoluteString)
            }
        }
    }
    
    func uploadUserProfileImage(image: UIImage, userId: String) async -> String?{
        let imageRef = storage.reference().child("userImage/\(userId)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else{
            print("StorageRepository: uploadUserProfileImage: fail to compress image")
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
