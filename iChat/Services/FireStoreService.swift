//
//  FireStoreService.swift
//  iChat
//
//  Created by Наталья Шарапова on 14.07.2022.
//

import Firebase
import FirebaseFirestore

class FirestoreService {
    
    // MARK: - Properties
    // singletone
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    private var waitingChatRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    var currentUser : MUser!
    
    // MARK: - Methods
    // get the user data from Firebase
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        
        let docRef = usersRef.document(user.uid)
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.canNotUnwrapToMUser))
                    return
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.canNotGetUsersInfo))
            }
        }
    }
    
    // save profile with the users data
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        
        // check necessary fields
        guard Validators.isFull(userName: username, description: description, sex: sex) else {
            completion(.failure(UserError.notFull))
            return
        }
        
        guard avatarImage != UIImage(named: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var muser = MUser(userName: username!,
                          email: email,
                          avatarStringURL: "not exist",
                          description: description!,
                          sex: sex!,
                          id: id)
        
        // upload the profile to the Firebase
        StorageService.shared.upload(photo: avatarImage!) { result in
            
            switch result {
            case .success(let url):
                muser.avatarStringURL = url.absoluteString
                self.usersRef.document(muser.id).setData(muser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(muser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    // create waiting chat in Firebase
    func createWaitingChat(message: String, receiver: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // reference to the folder "waitingChats"
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        
        // create reference to the collection "messages"
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        
        let chat = MChat(friendUserName: currentUser.userName,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         lastMessage: message.content,
                         friendId: currentUser.id)
        
        // create document in messages
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(Void()))
            }
        }
    }
    
    // delete waiting chat
    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // delete messages in document
        waitingChatRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let reference = waitingChatRef.document(chat.friendId).collection("messages")
        
        getWaitingChatMessage(chat: chat) { result in
            switch result {
            case .success(let messages):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRef = reference.document(documentId)
                    messageRef.delete { error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // get waiting chat message
    func getWaitingChatMessage(chat: MChat, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        
        // create reference to the collection "messages"
        let reference = waitingChatRef.document(chat.friendId).collection("messages")
        
        var messages = [MMessage]()
        
        reference.getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MMessage(document: document) else {
                    return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
    
    // change waiting chat to the active chat
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        
        getWaitingChatMessage(chat: chat) { result in
            
            switch result {
            case .success(let messages):
                self.deleteWaitingChat(chat: chat) { result in
                    switch result {
                    case .success:
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            switch result {
                            case .success:
                                completion(.success(Void()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // create active chat
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        
        // create reference to the collection "messages"
        let messageRef = activeChatRef.document(chat.friendId).collection("messages")
        
        activeChatRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for message in messages {
                messageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func sendMessage(chat: MChat, message: MMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // create references
        let friendRef = usersRef.document(chat.friendId).collection("activeChats").document(currentUser.id)
        let friendMessageRef = friendRef.collection("messages")
        let myMessageRef = usersRef.document(currentUser.id).collection("activeChats").document(chat.friendId).collection("messages")
        
        let chatForFriend = MChat(friendUserName: currentUser.userName,
                                  friendAvatarStringURL: currentUser.avatarStringURL,
                                  lastMessage: message.content,
                                  friendId: currentUser.id)
        
        friendRef.setData(chatForFriend.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            friendMessageRef.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                myMessageRef.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
}
