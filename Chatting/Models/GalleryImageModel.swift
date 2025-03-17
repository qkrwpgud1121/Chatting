//
//  GalleryImageModel.swift
//  Chatting
//
//  Created by 박제형 on 3/17/25.
//

import Foundation

struct GalleryImageModel: Codable {
    let date: String
    let url: String
    let size: Int
    let mimeType: String
    let name: String
}
