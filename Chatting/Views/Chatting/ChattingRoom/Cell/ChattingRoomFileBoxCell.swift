//
//  ChattingRoomFileBoxCell.swift
//  Chatting
//
//  Created by 박제형 on 3/14/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomFileBoxCell: UICollectionViewCell {
    
    static let identifier: String = "ChattingRoomFileBoxCell"
    
    let common = Common()
    var cellSelectMode: Bool = false
    
    private let fileType: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let fileName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let fileSize: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let btn_select: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        
        contentView.flex.justifyContent(.spaceBetween).padding(16).define { flex in
            flex.addItem().direction(.row).justifyContent(.spaceBetween).define { top in
                top.addItem(fileType).size(40)
                top.addItem(btn_select).size(30)
            }
            
            flex.addItem().define { bottomField in
                bottomField.addItem(fileName).marginBottom(8)
                bottomField.addItem(fileSize)
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
    
    func configure(type: String, name: String, size: String, selectMode: Bool) {
        cellSelectMode = selectMode
        fileType.image = setFileImage(type: type)
        fileName.text = name
        fileSize.text = size
        btn_select.isHidden = !selectMode
    }
    
    private func setFileImage(type: String) -> UIImage {
        
        switch type {
        case "pdf":
            return UIImage(named: "pdfLogo")!
        case "cell", "xlsx", "xlsm", "xlsb", "xltx":
            return UIImage(named: "excelLogo")!
        case "zip", "apk", "rar", "7z", "tar":
            return UIImage(named: "zipLogo")!
        case "ppt", "pptx", "pptm", "show":
            return UIImage(named: "pptxLogo")!
        case "doc", "docx", "hwp":
            return UIImage(named: "docLogo")!
        case "mp3", "mp4", "wma", "aac", "m4a":
            return UIImage(named: "soundLogo")!
        default:
            return UIImage(named: "folderLogo")!
        }
    }
    
    override var isSelected: Bool {
        didSet{
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
        
        contentView.layer.borderColor = common.commonBasicColor.cgColor
        contentView.layer.borderWidth = 2
        btn_select.backgroundColor = common.commonBasicColor
        btn_select.setImage(UIImage(systemName: "checkmark"), for: .normal)
        btn_select.tintColor = .white
    }
    
    func setDeselectedConfig() {
        
        contentView.layer.borderWidth = 0
        btn_select.backgroundColor = .white.withAlphaComponent(0.5)
        btn_select.setImage(nil, for: .normal)
    }
}
