//
//  tableViewCell.swift
//  Chatting
//
//  Created by 박제형 on 1/13/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class ChattingListCell: UITableViewCell {
    
    static let identifier = "ChattingListCell"
    
    let testView = UIView()
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    var lastChatLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    var lastChatTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = .zero
        
        contentView.flex.define { flex in
            flex.addItem().direction(.row).height(80).alignItems(.center).define { item in
                item.addItem(profileImage).size(50).marginRight(8)
                item.addItem(testView).direction(.row).define { view in
                    view.addItem().direction(.column).width(contentView.frame.width - 42).define { lableView in
                        lableView.addItem(nameLabel).marginBottom(4)
                        lableView.addItem(lastChatLable)
                    }
                    
                    view.addItem(lastChatTimeLabel).width(70)
                }
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
        testView.frame.size = contentView.sizeThatFits(contentView.frame.size)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
}
