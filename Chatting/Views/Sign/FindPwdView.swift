//
//  FindPassword.swift
//  Chatting
//
//  Created by 박제형 on 2/13/25.
//

import UIKit
import FlexLayout
import PinLayout

class FindPwdView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    var email: String = ""
    var currentEditingTextField: Int? = 0
    var nameValid: Bool = false
    var emailValid: Bool = false
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark", leading: 10))
        button.tintColor = .black
        return button
    }()
    
    private lazy var accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
    
    private lazy var lbl_desc: UILabel = {
        let label = UILabel()
        label.text = "이메일을 입력해주세요"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = common.commonBasicColor
        return label
    }()
    
    private let lb_descDetail: UILabel = {
        let label = UILabel()
        label.text = "작성하신 이메일 주소로 임시 비밀번호가 전송됩니다."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tf_email: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일 입력"
        textField.font = .systemFont(ofSize: 20)
        textField.tag = 0
        textField.keyboardType = .emailAddress
        textField.delegate = self
        return textField
    }()
    
    private lazy var tf_name: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름 입력"
        textField.font = .systemFont(ofSize: 20)
        textField.tag = 1
        textField.delegate = self
        return textField
    }()
    
    private lazy var btn_accessory: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = common.commonBasicColor
        return button
    }()
    
    private lazy var btn_confirm: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = common.commonBasicColor
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupButtonAction()
    }
    
    func setupButtonAction() {
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        btn_accessory.addAction(UIAction { _ in
            self.componentEvent(tag: self.currentEditingTextField!)
        }, for: .touchUpInside)
        
        btn_confirm.addAction(UIAction { _ in
            print("find password process~")
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        accessoryView.addSubview(btn_accessory)
        
        rootFlexView.flex.paddingHorizontal(32).define { flex in
            flex.addItem(lbl_desc).height(40).marginTop(32)
            flex.addItem(lb_descDetail).marginBottom(32)
            
            flex.addItem(tf_name).height(0)
            flex.addItem(tf_email).height(56)
            
            flex.addItem(btn_confirm)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        btn_confirm.pin.bottom().height(56)
        
        btn_accessory.pin.horizontally().vertically().height(56).marginHorizontal(32)
        
        tf_email.becomeFirstResponder()
    }
    
    private func componentEvent(tag: Int) {
        UIView.animate(withDuration: 0.3) {
            switch tag {
            case 0:
                self.tf_name.flex.height(56)
                self.tf_name.flex.markDirty()
                self.rootFlexView.flex.layout()
                self.lbl_desc.text = "이름을 입력해주세요"
                self.tf_name.becomeFirstResponder()
            case 1:
                self.view.endEditing(true)
                if self.nameValid && self.emailValid {
                    self.btn_confirm.isHidden = false
                }
            default: break
            }
        }
        btn_confirm.pin.bottom().height(56)
    }
    
    private func textFieldValidate(textField: UITextField) {
        
        switch textField.tag {
        case 0:
            emailValid = textField.text?.isValidEmail ?? false
            textField.setBottomBorder(color: emailValid ? .systemGreen : .systemRed, leftView: false)
        case 1:
            nameValid = textField.text!.length > 0
            textField.setBottomBorder(color: nameValid ? .systemGreen : .systemRed, leftView: false)
        default: break
        }
        
        if nameValid && emailValid {
            btn_confirm.isHidden = false
        }
    }
}

extension FindPwdView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.inputAccessoryView = accessoryView
        currentEditingTextField = textField.tag
        textField.setBottomBorder(color: common.commonBasicColor, leftView: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldValidate(textField: textField)
        currentEditingTextField = nil
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldValidate(textField: textField)
    }
}
