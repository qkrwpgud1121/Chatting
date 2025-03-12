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
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = contentView.frame.size.width / 2
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.flex.define { flex in
            flex.addItem(button)
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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
            } else {
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
}
