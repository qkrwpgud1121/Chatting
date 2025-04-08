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
    var cellSelectMode: Bool = false
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let btn_select: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.flex.define { flex in
            flex.addItem(imageView)
            flex.addItem(btn_select).size(30)
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
        btn_select.pin.topRight(to: imageView.anchor.topRight)
        
    }
    
    func configure(imageURL: String, selectMode: Bool) {
        cellSelectMode = selectMode
        imageView.image = UIImage(named: imageURL)
        btn_select.isHidden = !selectMode
    }
    
    override var isSelected: Bool {
        didSet {
            if cellSelectMode {
                setSelected()
            }
        }
    }
    
    func setSelected() {
        if isSelected {
            setSelectedConfig()
        } else {
            setDeselectedConfig()
        }
    }
    
    func setSelectedConfig() {
        
        imageView.layer.borderColor = common.commonBasicColor.cgColor
        imageView.layer.borderWidth = 2
        btn_select.backgroundColor = common.commonBasicColor
        btn_select.setImage(UIImage(systemName: "checkmark"), for: .normal)
        btn_select.tintColor = .white
    }
    
    func setDeselectedConfig() {
        
        imageView.layer.borderWidth = 0
        btn_select.backgroundColor = .white.withAlphaComponent(0.5)
        btn_select.setImage(nil, for: .normal)
    }
    
}
