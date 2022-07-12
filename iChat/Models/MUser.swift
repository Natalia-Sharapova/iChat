//
//  MUser.swift
//  iChat
//
//  Created by Наталья Шарапова on 12.07.2022.
//

import Foundation

struct MUser: Hashable, Decodable {
    var userName: String
    var userImageString: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
}
