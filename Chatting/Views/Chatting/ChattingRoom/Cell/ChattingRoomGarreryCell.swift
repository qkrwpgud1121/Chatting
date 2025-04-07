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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let imageSelected: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.flex.define { flex in
            flex.addItem(imageView).define { imageView in
                imageView.addItem(imageSelected)
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
        
        imageView.pin.all()
        imageSelected.pin.topRight(to: imageView.anchor.topRight)
        
    }
    
    func configure(imageURL: String, selectMode: Bool) {
        cellSelectMode = selectMode
        imageView.image = UIImage(named: imageURL)
        imageSelected.isHidden = !selectMode
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
            imageView.layer.borderColor = common.commonBasicColor.cgColor
            imageView.layer.borderWidth = 2
        } else {
            imageView.layer.borderWidth = 0
        }
    }
    
}
