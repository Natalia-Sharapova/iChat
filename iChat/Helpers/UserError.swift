//
//  UserError.swift
//  iChat
//
//  Created by Наталья Шарапова on 15.07.2022.
//

import Foundation

// MARK: - Enum for describing an errors
enum UserError {
    case photoNotExist
    case notFull
    case canNotGetUsersInfo
    case canNotUnwrapToMUser
}

extension UserError: LocalizedError {
    
    var errorDescription: String? {
        
        switch self {
        case .photoNotExist:
            return NSLocalizedString("No photo selected", comment: "")
        case .notFull:
            return NSLocalizedString("Fill all fields", comment: "")
        case .canNotGetUsersInfo:
            return NSLocalizedString("Impossible to load user's information", comment: "")
        case .canNotUnwrapToMUser:
            return NSLocalizedString("Impossible to convert MUser from User", comment: "")
        }
    }
}
