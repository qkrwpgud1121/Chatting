//
//  ChattingRoomBottomSheet.swift
//  Chatting
//
//  Created by 박제형 on 2/26/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomSettingView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    private lazy var lb_roomName: UILabel = {
        let label = UILabel()
        label.text = "채팅방 이름"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = self.common.commonBasicColor
        return label
    }()
    
    private lazy var tf_roomName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "채팅방 이름을 입력해 주세요"
        textField.delegate = self
        return textField
    }()
    
    private lazy var lb_roomBackgroundColor: UILabel = {
        let label = UILabel()
        label.text = "채팅방 배경색상"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = self.common.commonBasicColor
        return label
    }()
    
//    private let cv_roomBackgroundColor: UICollectionView = {
//        let collectionView = UICollectionView()
//        return collectionView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    private func initUI() {
        rootFlexView.backgroundColor = .white
        view.addSubview(rootFlexView)
        
        
        
        rootFlexView.flex.paddingHorizontal(32).define { flex in
            flex.addItem(lb_roomName).height(32).marginTop(16)
            flex.addItem(tf_roomName).height(48)
            
            flex.addItem(lb_roomBackgroundColor).height(48).marginTop(16)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        rootFlexView.flex.layout()
        
        setBottomBorder(color: .lightGray)
    }
    
    private func setBottomBorder(color: UIColor) {
        tf_roomName.setBottomBorder(color: color, leftView: false)
    }
    
}

extension ChattingRoomSettingView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setBottomBorder(color: common.commonBasicColor)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setBottomBorder(color: .lightGray)
    }
}
