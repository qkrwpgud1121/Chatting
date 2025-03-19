//
//  SearchFriendsCell.swift
//  Chatting
//
//  Created by 박제형 on 2/11/25.
//

import UIKit
import FlexLayout
import PinLayout

class SearchFriendsCell: UITableViewCell {
    
    static let identifier: String = "SearchFriendsCell"
    
    var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.flex.direction(.row).alignItems(.center).height(60).define { flex in
            flex.addItem(profileImage).size(40).marginRight(10)
            flex.addItem(nameLabel).grow(1)
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
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
}
