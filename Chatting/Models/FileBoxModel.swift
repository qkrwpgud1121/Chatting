//
//  FileBoxModel.swift
//  Chatting
//
//  Created by 박제형 on 3/19/25.
//

import Foundation

struct FileBoxModel: Codable {
    var mimeType: String
    var url: String
    var name: String
    var size: Int
    var date: String
}
