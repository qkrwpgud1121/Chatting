//
//  SignUpView.swift
//  Chatting
//
//  Created by 박제형 on 2/13/25.
//

import UIKit
import FlexLayout
import PinLayout

class SignPrivacyPolicyView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    var b_fullAgree: Bool = false
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark", leading: 10))
        button.tintColor = .black
        return button
    }()
    
    private let iv_hoduLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "hoduMainLogo")?.resized(newWidth: 120)
        return imageView
    }()
    
    private let lbl_greetings: UILabel = {
        let label = UILabel()
        label.text = "호두에 오신 것을\n환영합니다!"
        label.font = .systemFont(ofSize: 30, weight: .regular)
        label.numberOfLines = 2
        label.textColor = UIColor(hexCode: "769EFF")
        label.asFontColor(targetString: "호두에 오신 것을", font: .systemFont(ofSize: 20), color: UIColor(hexCode: "769EFF"))
        return label
    }()
    
    private let chk_fullAgree = CheckBox()
    private let lbl_fullAgree: UILabel = {
        let label = UILabel()
        label.text = "약관 전체 동의"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let chk_termsOfUse = CheckBox()
    private let lbl_termsOfUse: UILabel = {
        let label = UILabel()
        label.text = "(필수) 이용약관 동의"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.asFontColor(targetString: "(필수)", font: .systemFont(ofSize: 15), color: .red)
        return label
    }()
    private let btn_termsOfUse: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    private let chk_collectionUserInfo = CheckBox()
    private let lbl_collectionUserInfo: UILabel = {
        let label = UILabel()
        label.text = "(필수) 개인정보 수집 및 이용 동의"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.asFontColor(targetString: "(필수)", font: .systemFont(ofSize: 15), color: .red)
        return label
    }()
    private let btn_collectionUserInfo: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    private let chk_termOfService = CheckBox()
    private let lbl_termOfService: UILabel = {
        let label = UILabel()
        label.text = "(필수) 서비스 이용약관 동의"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.asFontColor(targetString: "(필수)", font: .systemFont(ofSize: 15), color: .red)
        return label
    }()
    private let lbl_termsOfServiceDesc: UILabel = {
        let label = UILabel()
        label.text = "고객 편의를 위한 간편가입 서비스 제공, 이용자 식별, 서비스 이용 및\n원활한 의사소 통 경로 확보, 부정이용 방지 목적."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray3
        label.numberOfLines = 0
        return label
    }()
    
    private let chk_verifyUserAge = CheckBox()
    private let lbl_verifyUserAge: UILabel = {
        let label = UILabel()
        label.text = "(필수) 만 14세 이상 사용자 확인"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.asFontColor(targetString: "(필수)", font: .systemFont(ofSize: 15), color: .red)
        return label
    }()
    
    private let btn_nextStep: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        btn_nextStep.pin.bottom()
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
        
        chk_fullAgree.addAction(UIAction { _ in
            
            self.b_fullAgree.toggle()
            
            self.chk_termsOfUse.isChecked = self.b_fullAgree
            self.chk_collectionUserInfo.isChecked = self.b_fullAgree
            self.chk_termOfService.isChecked = self.b_fullAgree
            self.chk_verifyUserAge.isChecked = self.b_fullAgree
            
            self.checkBoxSubscriptions()
            
        }, for: .touchUpInside)
        
        chk_termsOfUse.addAction(UIAction { _ in self.checkBoxSubscriptions()}, for: .touchUpInside)
        chk_collectionUserInfo.addAction(UIAction { _ in self.checkBoxSubscriptions()}, for: .touchUpInside)
        chk_termOfService.addAction(UIAction { _ in self.checkBoxSubscriptions()}, for: .touchUpInside)
        chk_verifyUserAge.addAction(UIAction { _ in self.checkBoxSubscriptions()}, for: .touchUpInside)
        
        btn_termsOfUse.addAction(UIAction { _ in
            self.presentPrivacyPolicy(type: .use)
        }, for: .touchUpInside)
        
        btn_collectionUserInfo.addAction(UIAction { _ in
            self.presentPrivacyPolicy(type: .userInfo)
        }, for: .touchUpInside)
        
        btn_nextStep.addAction(UIAction { _ in
            let privacyVC = SignUpView()
            let navigationController = UINavigationController(rootViewController: privacyVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.paddingHorizontal(32).define { flex in
            
            flex.addItem(iv_hoduLogo).alignSelf(.start).marginTop(60)
            flex.addItem(lbl_greetings).alignSelf(.start).marginTop(16).height(80)
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(120).define { fullAgreement in
                fullAgreement.addItem(chk_fullAgree).size(25).marginRight(8)
                fullAgreement.addItem(lbl_fullAgree)
            }
            
            flex.addItem(separatorView).height(1).marginTop(32)
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(32).define { termsOfUse in
                termsOfUse.addItem(chk_termsOfUse).size(25).marginRight(8)
                termsOfUse.addItem(lbl_termsOfUse).grow(1)
                termsOfUse.addItem(btn_termsOfUse).size(25).marginLeft(8)
            }
            
            flex.addItem().direction(.row).alignItems(.center).marginTop(32).define { collectUserInfo in
                collectUserInfo.addItem(chk_collectionUserInfo).size(25).marginRight(8)
                collectUserInfo.addItem(lbl_collectionUserInfo).grow(1)
                collectUserInfo.addItem(btn_collectionUserInfo).size(25).marginLeft(8)
            }
            
            flex.addItem().direction(.row).marginTop(32).define { collectUserInfo in
                collectUserInfo.addItem(chk_termOfService).size(25).marginRight(8)
                collectUserInfo.addItem().direction(.column).define { collectUserInfoDesc in
                    collectUserInfoDesc.addItem(lbl_termOfService).marginBottom(6)
                    collectUserInfoDesc.addItem(lbl_termsOfServiceDesc)
                }
            }
            
            flex.addItem().direction(.row).marginTop(32).define { collectUserInfo in
                collectUserInfo.addItem(chk_verifyUserAge).size(25).marginRight(8)
                collectUserInfo.addItem(lbl_verifyUserAge)
            }
            
            flex.addItem(btn_nextStep).height(56)
        }
    }
    
    private func checkBoxSubscriptions() {
        if chk_termsOfUse.isChecked && chk_collectionUserInfo.isChecked && chk_termOfService.isChecked && chk_verifyUserAge.isChecked {
            b_fullAgree = true
            chk_fullAgree.isChecked = true
            btn_nextStep.isEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.btn_nextStep.backgroundColor = UIColor(hexCode: "769EFF")
            }
        } else {
            b_fullAgree = false
            chk_fullAgree.isChecked = false
            btn_nextStep.isEnabled = false
            UIView.animate(withDuration: 0.3) {
                self.btn_nextStep.backgroundColor = .lightGray
            }
        }
    }
    
    private func presentPrivacyPolicy(type: privacyPolicyType) {
        
        let privacyVC = SignPrivacyPolicyDetailView()
        privacyVC.type = type
        privacyVC.onDismiss = { [weak self] data in
            if type == .use {
                self!.chk_termsOfUse.isChecked = data
                self!.checkBoxSubscriptions()
            } else {
                self!.chk_collectionUserInfo.isChecked = data
                self!.checkBoxSubscriptions()
            }
        }
        let navigationController = UINavigationController(rootViewController: privacyVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
}
