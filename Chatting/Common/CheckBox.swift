//
//  CheckBox.swift
//  Chatting
//
//  Created by 박제형 on 2/13/25.
//

import UIKit
import FlexLayout
import PinLayout

class CheckBox: UIButton {
    
    let checkedImage = UIImage(systemName: "checkmark")
    
    let color: CGColor = UIColor(hexCode: "769EFF").cgColor
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                setImage(checkedImage, for: .normal)
                tintColor = .white
                backgroundColor = UIColor(hexCode: "769EFF")
            } else {
                backgroundColor = .clear
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = color
        layer.masksToBounds = true
        layer.cornerRadius = 5
        backgroundColor = .clear
        
        addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toggleCheck() {
        isChecked.toggle()
    }
}
