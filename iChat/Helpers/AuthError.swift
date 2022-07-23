//
//  AuthError.swift
//  iChat
//
//  Created by Наталья Шарапова on 14.07.2022.
//

import Foundation

// MARK: - Enum for describing an errors
enum AuthError {
    case notFull
    case invalidEmail
    case passwordsNotMatched
    case unknownError
    case serverError
}

extension AuthError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .notFull:
            return NSLocalizedString("Fill all fields", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid email format", comment: "")
        case .passwordsNotMatched:
            return NSLocalizedString("Passwords isn't match", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}
