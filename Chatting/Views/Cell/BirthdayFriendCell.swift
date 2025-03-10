//
//  TableViewCell.swift
//  Chatting
//
//  Created by 박제형 on 1/10/25.
//

import Foundation
import UIKit
import PinLayout
import FlexLayout

class BirthdayFriendCell: UITableViewCell {
    
    static let identifier: String = "BirthdayFriendCell"
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    var birthdayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.flex.define { flex in
            flex .addItem().direction(.row).alignItems(.center).define { row in
                row.addItem(profileImage).size(50).marginRight(8)
                
                row.addItem().direction(.column).define { column in
                    column.addItem(nameLabel)
                    column.addItem(birthdayLabel)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
    }
}
