//
//  Validators.swift
//  iChat
//
//  Created by Наталья Шарапова on 14.07.2022.
//

import Foundation

class Validators {
    
    static func isFull(email: String?, password: String?, confirmPassword: String?) -> Bool {
        
        guard let email = email,
             let password = password,
             let confirmPassword = confirmPassword,
              password != "",
              email != "",
              confirmPassword != "" else {
            return false
        }
        return true
    }
    
    static func isSimpleEmail(email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}