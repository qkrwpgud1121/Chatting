//
//  ChattingListModel.swift
//  Chatting
//
//  Created by 박제형 on 1/6/25.
//

import Foundation

struct ChattingListModel: Codable {
    let chattingList: [ChattingList]
}

struct ChattingList: Codable {
    let profileImage: String?
    let name: String
    let lastChat: String
    let lastChatTime: String
}
