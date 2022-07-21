//
//  MMessage.swift
//  iChat
//
//  Created by Наталья Шарапова on 18.07.2022.
//

import UIKit
import FirebaseFirestore
import MessageKit

struct MMessage: Hashable, MessageType {
   
    var sender: SenderType
    
    let content: String
    let sentDate: Date
    let id: String?
    var image: UIImage? = nil
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
       // return .text(content)
        if let image = image {
            return .photo(<#T##MediaItem#>)
        } else {
            return .text(content)
        }
    }
    
    init(user: MUser, content: String) {
        self.content = content
        sender = Sender(senderId: user.id, displayName: user.userName)
        sentDate = Date()
        id = nil
    }
    
    init(user: MUser, image: UIImage) {
        sender = Sender(senderId: user.id, displayName: user.userName)
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
           let data = document.data()
           guard let sentDate = data["created"] as? Timestamp else { return nil }
           guard let senderId = data["senderID"] as? String else { return nil }
           guard let senderName = data["senderName"] as? String else { return nil }
           guard let content = data["content"] as? String else { return nil }
       
        self.id = document.documentID
        self.sentDate = sentDate.dateValue()
        sender = Sender(senderId: senderId, displayName: senderName)
        
        self.content = content
    }
    
    var representation: [String : Any] {
        
        let rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName,
            "content": content
        ]
        return rep  
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(messageId)
    }
    
    static func == (lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

extension MMessage: Comparable {
    static func <(lhs: MMessage, rhs: MMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
