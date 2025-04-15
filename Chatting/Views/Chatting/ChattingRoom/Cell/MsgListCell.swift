//
//  ChatMessageList.swift
//  Chatting
//
//  Created by 박제형 on 1/15/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class ChattingMsgListCell: UITableViewCell {
    
    let userId: String = "27489"
    
    static let identifier = "ChatMessageListCell"
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        label.clipsToBounds = true
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = .zero

    }
    
    func configure(with message: ChattingMsgData, profile: String) {
        
        profileImage.image = UIImage(named: profile)
        nameLabel.text = message.user_id
        messageLabel.text = message.data.msg
        timeLabel.text = sendTime(sendDate: message.send_date)
        
        contentView.flex.define { flex in
            
            timeLabel.isHidden = true
            
            if message.timeStamp ?? true {
                timeLabel.isHidden = false
            }
            
            if message.own! {
                flex.addItem().direction(.row).justifyContent(.end).marginHorizontal(16).height(40).define { item in
                    item.addItem(timeLabel).alignSelf(.end).marginRight(4)
                    item.addItem(messageLabel).backgroundColor(.yellow).cornerRadius(15).paddingHorizontal(8).marginVertical(2)
                }
            } else {
                flex.addItem().direction(.row).marginHorizontal(16).define { item in
                    item.addItem(profileImage).size(35).marginRight(4)
                    
                    if message.group ?? false {
                        
                        profileImage.isHidden = true
                        item.addItem().direction(.column).height(40).define { column in
                            column.addItem(messageLabel).cornerRadius(15).backgroundColor(.white).paddingHorizontal(8).marginVertical(2).grow(1)
                        }
                    } else {
                        
                        item.addItem().direction(.column).height(53).define { column in
                            column.addItem(nameLabel)
                            column.addItem(messageLabel).cornerRadius(15).backgroundColor(.white).paddingHorizontal(8).marginVertical(2).grow(1)
                        }
                    }
                    item.addItem(timeLabel).alignSelf(.end).marginLeft(4)
                }
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layout()
    }
    
    fileprivate func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
    
    func sendTime(sendDate: Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(sendDate) / 1000)
        let ls_time = Common.GF_DATE_TO_STRING(date, "a hh:mm", po_locale: Locale(identifier:"ko_KR"))
        
        return ls_time
    }
}
