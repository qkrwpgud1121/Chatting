//
//  ChattingRoomBottomSheet.swift
//  Chatting
//
//  Created by 박제형 on 2/26/25.
//

import UIKit
import FlexLayout
import PinLayout

protocol ChattingRoomSettingViewDelegate: AnyObject {
    func didChangeBackgroundColor(_ color: UIColor)
}

class ChattingRoomSettingView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    var load: Int = 0
    
    var chattingRoomName: String = ""
    
    weak var delegate: ChattingRoomSettingViewDelegate?
    
    let backgroundColor: [String] = [ "F9E1E2", "FCEED3", "FEF4D7", "F8D2E8", "D3EFF4", "D7F5EA", "DEF0FC", "DDE4FE", "E0DDFC", "D8D9DE" ]
    
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
    
    private lazy var cv_backgroundColor: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChattingRoomBackgroundColorCell.self, forCellWithReuseIdentifier: ChattingRoomBackgroundColorCell.identifier)
        return collectionView
    }()
    
    private lazy var btn_cancel: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.backgroundColor = .lightGray
        return button
    }()
    
    private lazy var btn_confirm: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.backgroundColor = common.commonBasicColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonAction()
    }
    
    private func buttonAction() {
        
        btn_cancel.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        btn_confirm.addAction(UIAction { _ in
            print("confirm")
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        rootFlexView.backgroundColor = .white
        view.addSubview(rootFlexView)
        
        tf_roomName.text = chattingRoomName
        
        rootFlexView.flex.justifyContent(.spaceBetween).paddingHorizontal(32).define { flex in
            
            flex.addItem().direction(.column).define { mainFlex in
                mainFlex.addItem(lb_roomName).height(32).marginTop(16)
                mainFlex.addItem(tf_roomName).height(48).marginBottom(8)
                
                mainFlex.addItem(lb_roomBackgroundColor).height(32).marginBottom(16)
                mainFlex.addItem(cv_backgroundColor).height(((view.frame.size.width - 64 - 32) / 5) * 2)
            }
            
            let buttonWidth = (view.frame.width - 64 - 8) / 2
            
            flex.addItem().height(50).direction(.row).marginBottom(34).define { bottomButtonFlex in
                bottomButtonFlex.addItem(btn_cancel).height(56).width(buttonWidth).marginRight(8)
                bottomButtonFlex.addItem(btn_confirm).height(56).width(buttonWidth)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        rootFlexView.flex.layout()
        
        load == 0 ? setBottomBorder(color: .systemGray5) : ()
    }
    
    private func setBottomBorder(color: UIColor) {
        tf_roomName.setBottomBorder(color: color, leftView: false)
        load += 1
    }
    
}

extension ChattingRoomSettingView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setBottomBorder(color: common.commonBasicColor)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setBottomBorder(color: .systemGray5)
    }
}

extension ChattingRoomSettingView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingRoomBackgroundColorCell.identifier, for: indexPath) as! ChattingRoomBackgroundColorCell
        
        let backgroundColor = UIColor(hexCode: backgroundColor[indexPath.row])
        
        cell.configure(background: backgroundColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backgroundColor = UIColor(hexCode: backgroundColor[indexPath.row])
        delegate?.didChangeBackgroundColor(backgroundColor)
    }
}

extension ChattingRoomSettingView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 5 - 16
        return CGSize(width: size, height: size)
    }
}
