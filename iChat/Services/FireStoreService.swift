//
//  FireStoreService.swift
//  iChat
//
//  Created by Наталья Шарапова on 14.07.2022.
//
import FirebaseFirestore
import Firebase

class FirestoreService {
    
    static let shared = FirestoreService()
    let dataBase = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return dataBase.collection("users")
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
}
