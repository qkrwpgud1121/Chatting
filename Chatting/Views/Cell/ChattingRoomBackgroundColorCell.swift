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
    
    private let button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.flex.define { flex in
            flex.addItem(button).size(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
        
        button.pin.horizontally().vertically()
    }
    
    func configure(background: UIColor) {
        button.backgroundColor = background
    }
    
}
