//
//  StorageService.swift
//  iChat
//
//  Created by Наталья Шарапова on 17.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StorageService {
    
    // MARK: - Properties
    //singletone
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var chatsRef: StorageReference {
        return storageRef.child("chats")
    }
    
    // load image to the Firebase
    func upload(photo: UIImage, completion: @escaping(Result<URL, Error>) -> Void) {
        
        // check right size for image
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { metaData, error in
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserId).downloadURL { url, error in
                guard let downloadUrl = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadUrl))
            }
        }
    }
    
    func uploadImageMessage(photo: UIImage, to chat: MChat, completion: @escaping(Result<URL, Error>) -> Void) {
        
        guard let scaledImage = photo.scaledToSafeUploadSize,
              let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        
        let uid: String = Auth.auth().currentUser!.uid
        
        let chatName = [chat.friendUserName, uid].joined()
        
        self.chatsRef.child(chatName).child(imageName).putData(imageData, metadata: metaData) { metaData, error in
            guard let _ = metaData else {
                completion(.failure(error!))
                return
            }
            self.chatsRef.child(chatName).child(imageName).downloadURL { url, error in
                guard let downloadUrl = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadUrl))
            }
        }
    }
    
    // download picture sent by a friend (inside the chat)
    func downloadImage(url: URL?, completion: @escaping(Result<UIImage?, Error>) -> Void) {
        
        let reference = Storage.storage().reference(forURL: url!.absoluteString)
        
        let megaByte = Int64(1 * 1024 * 1024)
        
        reference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }
}

