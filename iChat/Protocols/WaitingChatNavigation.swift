//
//  WaitingChatNavigation.swift
//  iChat
//
//  Created by Наталья Шарапова on 19.07.2022.
//

import Foundation

protocol WaitingChatNavigation: AnyObject {
    func removeWaitingChat(chat: MChat)
    func changeToActive(chat: MChat)
}
