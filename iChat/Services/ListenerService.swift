//
//  ListenerService.swift
//  iChat
//
//  Created by Наталья Шарапова on 18.07.2022.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    
    private let dataBase = Firestore.firestore()

    private var usersRef: CollectionReference {
        return dataBase.collection("users")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func usersObserver(users: [MUser], completion: @escaping (Result<[MUser], Error>) -> Void) -> ListenerRegistration? {
        
        var users = users
        
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { difference in
                guard let muser = MUser(document: difference.document) else {
                    return
                }
                switch difference.type {
                case .added:
                    guard !users.contains(muser) else { return }
                    guard muser.id != self.currentUserId else { return }
                    users.append(muser)
                case .modified:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users[index] = muser
                case .removed:
                    guard let index = users.firstIndex(of: muser) else { return }
                    users.remove(at: index)
                }
            }
            completion(.success(users))
        }
        return usersListener
    }
    
    func waitingChatsObserver(chats: [MChat], completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration? {

        var chats = chats
        
        let waitingChatsRef = dataBase.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        
        let chatsListener = waitingChatsRef.addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
        }
            snapshot.documentChanges.forEach { difference in
                guard let chat = MChat(document: difference.document) else { return }
                
                switch difference.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
}
return chatsListener
    }
    
    func activeChatsObserver(chats: [MChat], completion: @escaping (Result<[MChat], Error>) -> Void) -> ListenerRegistration? {

        var chats = chats
        
        let activeChatsRef = dataBase.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
        
        let chatsListener = activeChatsRef.addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
        }
            snapshot.documentChanges.forEach { difference in
                guard let chat = MChat(document: difference.document) else { return }
                
                switch difference.type {
                case .added:
                    guard !chats.contains(chat) else { return }
                    chats.append(chat)
                case .modified:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats[index] = chat
                case .removed:
                    guard let index = chats.firstIndex(of: chat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
}
return chatsListener
    }
    
    func messageObserver(chat: MChat, completion: @escaping (Result<MMessage, Error>) -> Void) -> ListenerRegistration? {
 
        let reference = usersRef.document(currentUserId).collection("activeChats").document(chat.friendId).collection("messages")
        
        let messageListener = reference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            snapshot.documentChanges.forEach { difference in
                guard let message = MMessage(document: difference.document) else {
                    return
                }
                
                switch difference.type {
                case .added:
                    completion(.success(message))
                case .modified:
                    break
                case .removed:
                    break
                }
            }
            
        }
        return messageListener
}
}
