//
//  AddChattingModel.swift
//  Chatting
//
//  Created by 박제형 on 1/24/25.
//

import Foundation

struct AddChattingModel: Codable {
    let Friends: [AddFriends]
}

struct AddFriends: Codable {
    var userId: String
    var profileImage: String?
    var name: String
    var selected: Bool? = false
}
