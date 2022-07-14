//
//  AuthService.swift
//  iChat
//
//  Created by Наталья Шарапова on 14.07.2022.
//

import UIKit
import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    func register(email: String?, password: String?, confirmPassword: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard Validators.isFull(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthError.notFull))
            return
        }
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthError.passwordsNotMatched))
            return
        }
        guard  Validators.isSimpleEmail(email: email!) else {
            completion(.failure(AuthError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    func signIn(email: String?, password: String?, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let email = email,
              let password = password else {
            completion(.failure(AuthError.notFull))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}

