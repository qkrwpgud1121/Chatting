//
//  SignUpView.swift
//  Chatting
//
//  Created by 박제형 on 2/17/25.
//

import UIKit
import FlexLayout
import PinLayout

class SignUpView: UIViewController {
    
    let common = Common()
    
    var currentEditingTextField: Int?
    
    var emailValid: Bool = false
    var passwordValid: Bool = false
    var passwordCheckValid: Bool = false
    var isShowPwd: Bool = false
    var isShowPwdChk: Bool = false
    
    let rootFlexView = UIView()
    
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
    
    private lazy var tf_email: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일 입력"
        textField.font = .systemFont(ofSize: 20)
        textField.keyboardType = .emailAddress
        textField.rightViewMode = .unlessEditing
        textField.tag = 0
        textField.delegate = self
        return textField
    }()
    
    private let lb_descDetail: UILabel = {
        let label = UILabel()
        label.text = "중요한 알림이 이메일을 통해 안내됩니다.\n본인이 사용하는 이메일을 입력해주세요."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var btn_showPwd: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()
    private lazy var tf_password: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 입력"
        textField.font = .systemFont(ofSize: 20)
        textField.rightView = btn_showPwd
        textField.rightViewMode = .whileEditing
        textField.autocorrectionType = .no
        textField.tag = 3
        textField.delegate = self
        return textField
    }()
    
    private lazy var btn_showPwdChk: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()
    private lazy var tf_passwordChk: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 확인"
        textField.font = .systemFont(ofSize: 20)
        textField.rightView = btn_showPwdChk
        textField.rightViewMode = .whileEditing
        textField.autocorrectionType = .no
        textField.tag = 4
        textField.delegate = self
        return textField
    }()
    
    private lazy var btn_next: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = common.commonBasicColor
        return button
    }()
    
    private lazy var btn_nextPage: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
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
        
        btn_showPwd.addAction(UIAction { sender in
            self.isShowPwd.toggle()
            if !self.isShowPwd {
                self.btn_showPwd.setImage(UIImage(systemName: "eye"), for: .normal)
                self.tf_password.isSecureTextEntry = true
            } else {
                self.btn_showPwd.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                self.tf_password.isSecureTextEntry = false
            }
        }, for: .touchUpInside)
        
        btn_showPwdChk.addAction(UIAction { _ in
            self.isShowPwdChk.toggle()
            if !self.isShowPwdChk {
                self.btn_showPwdChk.setImage(UIImage(systemName: "eye"), for: .normal)
                self.tf_passwordChk.isSecureTextEntry = true
            } else {
                self.btn_showPwdChk.setImage(UIImage(systemName: "eye.slash"), for: .normal)
                self.tf_passwordChk.isSecureTextEntry = false
            }
        }, for: .touchUpInside)
        
        btn_next.addAction(UIAction { _ in
            self.componentEvent(tag: self.currentEditingTextField!)
        }, for: .touchUpInside)
        
        btn_nextPage.addAction(UIAction { _ in
            let signUpProfileVC = SignUpProfileView()
            let navigationController = UINavigationController(rootViewController: signUpProfileVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        accessoryView.addSubview(btn_next)
        
        rootFlexView.flex.paddingHorizontal(32).define { flex in
            
            flex.addItem(lbl_desc).height(40).marginTop(32)
            flex.addItem(lb_descDetail).marginBottom(32)
            
            flex.addItem(tf_passwordChk).height(0)
            flex.addItem(tf_password).height(0)
            
            flex.addItem(tf_email).height(56).marginBottom(4)
            
            flex.addItem(btn_nextPage).height(56)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        btn_next.pin.horizontally().vertically().height(56).marginHorizontal(32)
        
        btn_nextPage.pin.bottom()
        
        tf_email.becomeFirstResponder()
        
        tf_email.setBottomBorder(color: common.commonBasicColor, leftView: false)
        
    }
    
    func componentEvent(tag: Int){
        
        UIView.animate(withDuration: 0.3) {
            
            switch tag {
            case 0:
                self.tf_password.flex.height(56).marginBottom(8)
                self.tf_password.flex.markDirty()
                self.rootFlexView.flex.layout()
                self.tf_password.becomeFirstResponder()
                self.tf_password.isSecureTextEntry = true
                self.lbl_desc.text = "비밀 번호를 입력해주세요"
                self.lb_descDetail.text = "8~20자, 영문 대/소문자, 숫자, 특수문자 중 두 가지 이상으로 조합"
            case 3:
                self.tf_passwordChk.flex.height(56).marginBottom(8)
                self.tf_passwordChk.flex.markDirty()
                self.rootFlexView.flex.layout()
                self.tf_passwordChk.becomeFirstResponder()
                self.tf_passwordChk.isSecureTextEntry = true
            case 4:
                self.view.endEditing(true)
                if self.emailValid && self.passwordValid && self.passwordCheckValid {
                    self.btn_nextPage.isHidden = false
                }
            default:break
            }
        }
        btn_nextPage.pin.bottom()
    }
    
    private func textFieldValidate(textField: UITextField) {
        
        switch textField.tag {
        case 0:
            emailValid = textField.text?.isValidEmail ?? false
            textField.setBottomBorder(color: emailValid ? .systemGreen : .systemRed, leftView: false)
        case 3:
            passwordValid = textField.text?.isValidPassword ?? false
            textField.setBottomBorder(color: passwordValid ? .systemGreen : .systemRed, leftView: false)
        case 4:
            if tf_passwordChk.text?.length == 0 || textField.text != tf_password.text {
                passwordCheckValid = false
            } else {
                passwordCheckValid = true
            }
            textField.setBottomBorder(color: passwordCheckValid ? .systemGreen : .systemRed, leftView: false)
        default: break
        }
        
        if emailValid && passwordValid && passwordCheckValid {
            self.btn_nextPage.isHidden = false
        }
    }
    
}

extension SignUpView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            textField.inputAccessoryView = nil
        } else {
            textField.inputAccessoryView = accessoryView
        }
        textField.setBottomBorder(color: common.commonBasicColor, leftView: false)
        currentEditingTextField = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldValidate(textField: textField)
        currentEditingTextField = nil
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldValidate(textField: textField)
    }
    
}
