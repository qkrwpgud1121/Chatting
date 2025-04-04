//
//  ChattingRoomFileBoxCell.swift
//  Chatting
//
//  Created by 박제형 on 3/14/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomGalleryCell: UICollectionViewCell {
    
    static let identifier: String = "ChattingRoomGalleryCell"
    
    let common = Common()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.flex.define { flex in
            flex.addItem(imageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.pin.all()
        contentView.flex.layout()
        
        imageView.pin.all()
        
    }
    
    func configure(imageURL: String) {
        imageView.image = UIImage(named: imageURL)
    }
    
    override var isSelected: Bool {
        didSet {
            //setSelected()
        }
    }
    
    func setSelected() {
        if isSelected {
            imageView.layer.borderColor = common.commonBasicColor.cgColor
            imageView.layer.borderWidth = 2
        } else {
            imageView.layer.borderWidth = 0
        }
    }
    
}
