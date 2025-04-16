//
//  CustomPreviewItem.swift
//  Chatting
//
//  Created by 박제형 on 4/16/25.
//

import Foundation
import QuickLook

class CustomPreviewItem: NSObject, QLPreviewItem {
    var previewItemURL: URL?
    var previewItemTitle: String?
    
    init(previewItemURL: URL, previewItemTitle: String) {
        self.previewItemURL = previewItemURL
        self.previewItemTitle = previewItemTitle
    }
}
