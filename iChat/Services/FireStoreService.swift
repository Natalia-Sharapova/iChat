//
//  FireStoreService.swift
//  iChat
//
//  Created by Наталья Шарапова on 14.07.2022.
//
/*import FirebaseFirestore
import Firebase

class FirestoreService {
    
    static let shared = FirestoreService()
    let dataBase = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return dataBase.collection("users")
    }
    
    private var waitingChatsRef: CollectionReference {
        return dataBase.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatRef: CollectionReference {
        return dataBase.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
    var currentUser: MUser!
    
    func getUserData(user: User, completion: @escaping (Result<MUser, Error>) -> Void) {
        
        let docref = usersRef.document(user.uid)
        docref.getDocument { document, error in
            if let document = document, document.exists {
                guard let muser = MUser(document: document) else {
                    completion(.failure(UserError.canNotUnwrapToMUser))
                    print(#line, #function, "canNotUnwrapToMUser ")
                    return 
                }
                self.currentUser = muser
                completion(.success(muser))
            } else {
                completion(.failure(UserError.canNotGetUsersInfo))
                print(#line, #function, "canNotGetUsersInfo")
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, userName: String?, sex: String?, avatarImageString: UIImage?, description: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        
        guard Validators.isFull(userName: userName, description: description, sex: sex) else {
            completion(.failure(UserError.notFull))
            return 
        }
        
        guard avatarImageString != #imageLiteral(resourceName: "avatar") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var muser = MUser(userName: userName!,
                          email: email,
                          avatarStringURL: "not exist",
                          description: description!,
                          sex: sex!,
                          id: id)
        
        StorageService.shared.upload(photo: avatarImageString!) { result in
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
    
    func createWaitingChat(message: String, userReceiver: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = dataBase.collection(["users", userReceiver.id, "waitingChats"].joined(separator: "/"))
        
        let messageReference = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        
        let chat = MChat(friendUserName: currentUser.userName,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         lastMessage: message.content,
                         friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
            }
            messageReference.addDocument(data: message.representation) { error in
                if let error = error {
                    completion(.failure(error))
                }
                completion(.success(Void()))
            }
           
        }
    }
    
    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        
        waitingChatsRef.document(chat.friendId).delete { error in
            if let error = error {
                completion(.failure(error))
            }
            self.deleteMessages(chat: chat, completion: completion)
        }
    }
    
    func deleteMessages(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
            
            let reference = waitingChatsRef.document(chat.friendId).collection("messages")
            
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
    
    func getWaitingChatMessage(chat: MChat, completion: @escaping (Result<[MMessage], Error>) -> Void) {
          
          let reference = waitingChatsRef.document(chat.friendId).collection("messages")
          var messages = [MMessage]()
          reference.getDocuments { querySnapshot, error in
            print(#line, #function)
              if let error = error {
                  completion(.failure(error))
                print(String(describing: error), #line, #function)
                  return
              }
              for document in querySnapshot!.documents {
                  guard let message = MMessage(document: document) else { return }
                  messages.append(message)
              }
              completion(.success(messages))
          }
      }
    
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping(Result<Void, Error>) -> Void) {
        
        let messageReference = activeChatRef.document(chat.friendId).collection("messages")
            
        activeChatRef.document(chat.friendId).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
            }
            for message in messages {
                messageReference.addDocument(data: message.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    }
                    completion(.success(Void()))
                }
            }
        }
    }
    
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        print(#function, #line)
        
        getWaitingChatMessage(chat: chat) { result in
            
            switch result {
            case .success(let messages):
                print(#function, #line)
                
                self.deleteWaitingChat(chat: chat) { result in
                    print(#function, #line)
                    switch result {
                    case .success:
                        print(#function, #line)
                        self.createActiveChat(chat: chat, messages: messages) { result in
                            print(#function, #line)
                            switch result {
                            case .success:
                                completion(.success(Void()))
                                print(#function, #line)
                            case .failure(let error):
                                completion(.failure(error))
                                print(#function, String(describing: error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        print(#function, String(describing: error))
                    }
                    print(#function, #line)
                }
            case .failure(let error):
                completion(.failure(error))
                print(#function, String(describing: error))
            }
            print(#function, #line)
        }
        
        print(#function, #line)
    }
   
}*/
import Firebase
import FirebaseFirestore

class FirestoreService {
    
    static let shared = FirestoreService()
    
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    var currentUser : MUser!
    
    private var waitingChatRef: CollectionReference {
        return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    private var activeChatRef: CollectionReference {
        return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
    }
    
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
    
    func saveProfileWith(id: String, email: String, username: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MUser, Error>) -> Void) {
        
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
    
    func createWaitingChat(message: String, receiver: MUser, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
        let messageRef = reference.document(self.currentUser.id).collection("messages")
        
        let message = MMessage(user: currentUser, content: message)
        
        let chat = MChat(friendUserName: currentUser.userName,
                         friendAvatarStringURL: currentUser.avatarStringURL,
                         lastMessage: message.content,
                         friendId: currentUser.id)
        
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
    
    func deleteWaitingChat(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        
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
    
    func getWaitingChatMessage(chat: MChat, completion: @escaping (Result<[MMessage], Error>) -> Void) {
        
        let reference = waitingChatRef.document(chat.friendId).collection("messages")
        var messages = [MMessage]()
        print(#line, #function)
        reference.getDocuments { querySnapshot, error in
            print(#line, #function)
            if let error = error {
                completion(.failure(error))
                print(#line, #function)
                return
            }
            for document in querySnapshot!.documents {
                print(#line, #function)
                print(querySnapshot!.documents.count)
                guard let message = MMessage(document: document) else {
                    print(#line, #function)
                    return }
                messages.append(message)
                print(#line, #function)
            }
            completion(.success(messages))
            print(messages)
            print(#line, #function)
        }
    }
    
    func changeToActive(chat: MChat, completion: @escaping (Result<Void, Error>) -> Void) {
        
        print(#line, #function)
        getWaitingChatMessage(chat: chat) { result in
            print(#line, #function)
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
            print(#line, #function)
        }
        print(#line, #function)
    }
    
    func createActiveChat(chat: MChat, messages: [MMessage], completion: @escaping (Result<Void, Error>) -> Void) {
        
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
