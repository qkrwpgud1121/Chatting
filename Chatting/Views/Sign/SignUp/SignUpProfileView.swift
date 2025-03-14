//
//  SignUpProfileView.swift
//  Chatting
//
//  Created by 박제형 on 2/21/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class SignUpProfileView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    var nameValid: Bool = false
    var phoneNumValid: Bool = false
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark", leading: 10))
        button.tintColor = .black
        return button
    }()
    
    private lazy var iv_profile: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "web-hoduchat_user_square")
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var btn_profileAdd: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "plus"))
        button.tintColor = .white
        button.backgroundColor = common.commonBasicColor
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    private lazy var tf_name: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름 입력"
        textField.font = .systemFont(ofSize: 20)
        textField.tag = 1
        textField.delegate = self
        return textField
    }()
    
    private lazy var tf_phoneNum: UITextField = {
        let textField = UITextField()
        textField.placeholder = "휴대폰번호 입력"
        textField.font = .systemFont(ofSize: 20)
        textField.keyboardType = .numberPad
        textField.tag = 2
        textField.delegate = self
        return textField
    }()
    
    private lazy var btn_signUp: UIButton = {
        let button = UIButton()
        button.setTitle("회원 가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
        button.isEnabled = false
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
        
        btn_profileAdd.addAction(UIAction { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }, for: .touchUpInside)
        
        btn_signUp.addAction(UIAction { _ in
            print("Sign up processing~")
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.paddingHorizontal(32).define { flex in
            
            flex.addItem(iv_profile).size(120).alignSelf(.center).marginVertical(48)
            flex.addItem(btn_profileAdd)
            
            flex.addItem(tf_name).height(56).marginBottom(8)
            flex.addItem(tf_phoneNum).height(56).marginBottom(8)
            
            flex.addItem(btn_signUp)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        btn_profileAdd.pin.bottomRight(to: iv_profile.anchor.bottomRight).size(30)
        
        btn_signUp.pin.bottom().height(56)
        
        tf_name.setBottomBorder(color: .systemGray5, leftView: false)
        tf_phoneNum.setBottomBorder(color: .systemGray5, leftView: false)
    }
    
    private func textFieldValidate(textField: UITextField) {
        
        switch textField.tag {
        case 1:
            if textField.text!.length > 0 {
                nameValid = true
            } else {
                nameValid = false
            }
            textField.setBottomBorder(color: nameValid ? .systemGreen : .systemRed, leftView: false)
        case 2:
            phoneNumValid = textField.text!.isValidPhoneNum
            textField.setBottomBorder(color: phoneNumValid ? .systemGreen : .systemRed, leftView: false)
        default:
            textField.setBottomBorder(color: .systemGray5, leftView: false)
        }
        
        if nameValid && phoneNumValid {
            btn_signUp.isEnabled = true
            btn_signUp.backgroundColor = common.commonBasicColor
        } else {
            btn_signUp.isEnabled = false
            btn_signUp.backgroundColor = .lightGray
        }
    }
}

extension SignUpProfileView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomBorder(color: common.commonBasicColor, leftView: false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldValidate(textField: textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldValidate(textField: textField)
    }
}

extension SignUpProfileView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.iv_profile.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
