//
//  ChattingRoomBackgroundColorCell.swift
//  Chatting
//
//  Created by 박제형 on 3/12/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomBackgroundColorCell: UICollectionViewCell {
    
    static let identifier: String = "ChattingRoomBackgroundColorCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = contentView.frame.size.width / 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func configure(background: UIColor) {
        contentView.backgroundColor = background
    }
    
}
