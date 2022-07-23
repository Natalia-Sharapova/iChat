//
//  AuthService.swift
//  iChat
//
//  Created by Наталья Шарапова on 14.07.2022.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class AuthService {
    
    // MARK: - Properties
    // singleton
    static let shared = AuthService()
    private let auth = Auth.auth()
    
    // MARK: - Methods
    // registration with email
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
        
        // creating the user in the Firebase
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
    
    // registration with Google
    func googleLogin(viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        
        // check client ID
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        // sign in Google
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard let result = result else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(result.user))
            }
        }
    }
    
    // sign in with email
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

