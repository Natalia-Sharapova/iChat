//
//  MChat.swift
//  iChat
//
//  Created by Наталья Шарапова on 12.07.2022.
//

import Foundation
import FirebaseFirestore

struct MChat: Hashable, Decodable {
    
    var friendUserName: String
    var friendAvatarStringURL: String
    var lastMessage: String
    var friendId: String
    
    var representation: [String:Any] {
        
        var rep = ["friendUserName": friendUserName]
        rep["friendAvatarStringURL"] = friendAvatarStringURL
        rep["lastMessage"] = lastMessage
        rep["friendId"] = friendId
        return rep
    }
    
    init(friendUserName: String, friendAvatarStringURL: String, lastMessage: String, friendId: String) {
        self.friendId = friendId
        self.friendUserName = friendUserName
        self.lastMessage = lastMessage
        self.friendAvatarStringURL = friendAvatarStringURL
    }
    
    init?(document: QueryDocumentSnapshot) {
        
        let data = document.data()
        guard let friendUserName = data["friendUserName"] as? String,
              let friendAvatarStringURL = data["friendAvatarStringURL"] as? String,
              let lastMessage = data["lastMessage"] as? String,
              let friendId = data["friendId"] as? String else { return nil }
        
        self.friendUserName = friendUserName
        self.friendAvatarStringURL = friendAvatarStringURL
        self.lastMessage = lastMessage
        self.friendId = friendId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendId)
    }
    static func == (lhs: MChat, rhs: MChat) -> Bool {
        return lhs.friendId == rhs.friendId
    }
}
