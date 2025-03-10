//
//  Method.swift
//  indicator
//
//  Created by 박제형 on 1/10/25.
//

import Foundation

struct FriendListModel: Codable {
    let birthdayFriends: [BirthdayFriend]
    let favoriteFriends: [FavoriteFriend]
    let friends: [Friends]
}

struct BirthdayFriend: Codable {
    let favorite: Bool
    let profileImage: String?
    let name: String
    let birthDate: String
}

struct FavoriteFriend: Codable {
    let favorite: Bool
    let profileImage: String?
    let name: String
    let status: String?
}

struct Friends: Codable {
    let favorite: Bool
    let profileImage: String?
    let name: String
    let status: String?
}
