//
//  AddChattingCell.swift
//  Chatting
//
//  Created by 박제형 on 1/24/25.
//

import Foundation
import UIKit

class AddChattingCell: UITableViewCell {
    
    static let identifier: String = "AddChattingCell"
    
    let common = Common()
    
    var position: Int = 0
    
    let profileImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var checkBoxButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "circle"))
        button.tintColor = .systemGray4
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.flex.direction(.row).alignItems(.center).height(60).define { flex in
            flex.addItem(profileImageView).size(40).marginRight(10)
            flex.addItem(nameLabel).grow(1)
            flex.addItem(checkBoxButton).size(20).marginLeft(8)
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
