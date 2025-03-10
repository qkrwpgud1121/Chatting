//
//  ChattingMsgListModel.swift
//  Chatting
//
//  Created by 박제형 on 1/16/25.
//

import Foundation

struct ChattingMsgListModel: Codable {
    let type: String
    let sub_type: String
    let data: [ChattingMsgData]
    let user_id: String
    let channel_uid: String
    let send_date: Date
}

struct ChattingMsgData: Codable {
    let type: String
    let sub_type: String
    let data: dataMsg
    let channel_uid: String
    let user_id: String
    let send_date: Double
    let idx: Int
    var own: Bool? = false
    var group: Bool? = false
    var timeStamp: Bool? = true
}

struct dataMsg: Codable {
    let msg: String
}
