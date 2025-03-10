//
//  ViewController.swift
//  Chatting
//
//  Created by 박제형 on 1/6/25.
//

import UIKit
import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import KakaoSDKUser
import GoogleSignIn
import AuthenticationServices

class LoginView: UIViewController {
    
    let common = Common()

    private var viewModel = LoginViewModel()
    
    var disposeBag = DisposeBag()
    
    let rootFlexContainer = UIView()
    
    var isLogin: Bool = false
    var loginType: String = "email"
    let basicColor = UIColor(hexCode: "769EFF")
    var isShowPwd: Bool = false
    
    private let iv_hoduLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "hoduMainLogo")
        return imageView
    }()
    
    private lazy var lbl_hoduLogo: UILabel = {
        let label = UILabel()
        label.text = "MANAGE AND SHARE YOUR LIFE"
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = basicColor
        return label
    }()
    
    private lazy var emailLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle( "이메일 로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(basicColor, for: .normal)
        return button
    }()
    
    private lazy var loginTypeSeparateView: UIView = {
        let view = UIView()
        view.backgroundColor = basicColor
        return view
    }()
    
    private let phoneNumLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("휴대폰 로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.systemGray3, for: .normal)
        return button
    }()
    
    private lazy var tv_id: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
        textField.delegate = self
        return textField
    }()
    
    private lazy var btn_showPwd: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .systemGray3
        return button
    }()
    private lazy var tv_pwd: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.isSecureTextEntry = true
        textField.clearsOnInsertion = false
        textField.clearsOnBeginEditing = false
        textField.rightView = btn_showPwd
        textField.rightViewMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    private var btn_saveId = CheckBox()
    
    private lazy var lbl_saveId: UILabel = {
        let label = UILabel()
        label.text = "로그인 유지"
        label.textColor = basicColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let btn_login: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    private lazy var btn_findPwd: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(basicColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private lazy var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = basicColor
        return view
    }()
    
    private lazy var btn_sign: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(basicColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private lazy var easyLoginSeparator1: UIView = {
        let view = UIView()
        view.backgroundColor = common.commonBasicColor
        return view
    }()
    
    private lazy var lb_easyLogin: UILabel = {
        let label = UILabel()
        label.text = "간편 로그인"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = common.commonBasicColor
        label.sizeToFit()
        return label
    }()
    
    private lazy var easyLoginSeparator2: UIView = {
        let view = UIView()
        view.backgroundColor = common.commonBasicColor
        return view
    }()
    
    private lazy var btn_kakaoLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_logo_empty"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor(hexCode: "FEE500")
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    private lazy var btn_googleLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "google_logo"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray5.cgColor
        return button
    }()
    
    private lazy var btn_appleLogin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "apple_logo"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = .black
        button.layer.cornerRadius = 30
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    /// 임시
    private let btn_login1: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .lightGray
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initUI()
        
    }
    
    func initUI() {
        
        rootFlexContainer.backgroundColor = .white
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).define { flex in
            
            flex.addItem(iv_hoduLogo).alignSelf(.center).marginTop(150).marginBottom(32)
            flex.addItem(lbl_hoduLogo).alignSelf(.center).marginBottom(80)
            
            flex.addItem().direction(.row).marginBottom(16).define { loginType in
                loginType.addItem(emailLoginButton).grow(1)
                loginType.addItem(loginTypeSeparateView).alignSelf(.center).width(2).height(15)
                loginType.addItem(phoneNumLoginButton).grow(1)
            }
            
            flex.addItem().marginHorizontal(32).define { item in
                
                item.addItem(tv_id).height(56).marginBottom(8)
                item.addItem(tv_pwd).height(56).marginBottom(16)
                
                item.addItem().direction(.row).marginBottom(16).define { saveId in
                    saveId.addItem(btn_saveId).alignSelf(.start).marginRight(4).size(25)
                    saveId.addItem(lbl_saveId)
                }
                
                item.addItem(btn_login).height(56)
            }
            
            flex.addItem().direction(.row).marginTop(16).paddingHorizontal(16).define { sign in
                sign.addItem(btn_findPwd).width((view.frame.width - 32 - 2) / 2)
                sign.addItem(separateView).alignSelf(.center).width(2).height(15)
                sign.addItem(btn_sign).width((view.frame.width - 32 - 2) / 2)
            }
            
            flex.addItem().direction(.row).height(40).marginTop(32).paddingHorizontal(32).define { separateView in
                separateView.addItem(easyLoginSeparator1).height(1).grow(1).alignSelf(.center)
                separateView.addItem(lb_easyLogin).marginHorizontal(8)
                separateView.addItem(easyLoginSeparator2).height(1).grow(1).alignSelf(.center)
            }
            
            flex.addItem().direction(.row).justifyContent(.spaceEvenly).marginTop(32).paddingHorizontal(32).define { easyLogin in
                easyLogin.addItem(btn_kakaoLogin).size(60)
                easyLogin.addItem(btn_googleLogin).size(60)
                easyLogin.addItem(btn_appleLogin).size(60)
            }
            /// 임시
            flex.addItem(btn_login1).height(56)
        }
        
        bindUI()
        
        btn_login.addAction(UIAction { _ in
            let nextVC = TabbarView()
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }, for: .touchUpInside)
        
        /// 임시
        btn_login1.addAction(UIAction { _ in
            let modalVC = ChattingRoomSettingView()
            modalVC.modalPresentationStyle = .pageSheet
            if let sheet = modalVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.largestUndimmedDetentIdentifier = nil
            }
            self.present(modalVC, animated: true)
        }, for: .touchUpInside)
        
        btn_saveId.addAction(UIAction { _ in
            
        }, for: .touchUpInside)
        
        emailLoginButton.addAction(UIAction { _ in
            self.loginType = "email"
            self.emailLoginButton.setTitleColor(self.basicColor, for: .normal)
            self.phoneNumLoginButton.setTitleColor(.systemGray3, for: .normal)
            self.tv_id.placeholder = "이메일"
            self.tv_id.text = ""
        }, for: .touchUpInside)
        
        phoneNumLoginButton.addAction(UIAction { _ in
            self.loginType = "phoneNum"
            self.phoneNumLoginButton.setTitleColor(self.basicColor, for: .normal)
            self.emailLoginButton.setTitleColor(.systemGray3, for: .normal)
            self.tv_id.placeholder = "휴대폰"
            self.tv_id.text = ""
        }, for: .touchUpInside)
        
        btn_showPwd.addAction(UIAction { _ in
            self.isShowPwd.toggle()
            self.tv_pwd.isSecureTextEntry.toggle()
            self.btn_showPwd.setImage(UIImage(systemName: self.isShowPwd ? "eye.slash" : "eye"), for: .normal)
        }, for: .touchUpInside)
        
        btn_findPwd.addAction(UIAction { _ in
            let findPwdVC = FindPwdView()
            findPwdVC.email = self.tv_id.text ?? ""
            let navigationController = UINavigationController(rootViewController: findPwdVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)            
        }, for: .touchUpInside)
        
        btn_sign.addAction(UIAction { _ in
            let signUpVC = SignPrivacyPolicyView()
            let navigationController = UINavigationController(rootViewController: signUpVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }, for: .touchUpInside)
        
        btn_kakaoLogin.addAction(UIAction { _ in
            self.kakaoLogin()
        }, for: .touchUpInside)
        
        btn_googleLogin.addAction(UIAction { _ in
            self.googleLogin()
        }, for: .touchUpInside)
        
        btn_appleLogin.addAction(UIAction { _ in
            self.appleLogin()
        }, for: .touchUpInside)
        
    }
    
    private func bindUI() {
        
        let idOb = tv_id.rx.text.orEmpty.asObservable()
        let idCkOb = idOb.map(checkId)
        
        let pwOb = tv_pwd.rx.text.orEmpty.asObservable()
        let pwCkOb = pwOb.map(checkPw)
        
        Observable.combineLatest(idCkOb, pwCkOb, resultSelector: { $0 && $1 })
            .subscribe(onNext: { btnInValid in
                if btnInValid {
                    self.btn_login.isEnabled = btnInValid
                    UIView.animate(withDuration: 0.5, animations: {
                        self.btn_login.backgroundColor = self.basicColor
                    })
                } else {
                    self.btn_login.isEnabled = btnInValid
                    UIView.animate(withDuration: 0.5, animations: {
                        self.btn_login.backgroundColor = .lightGray
                    })
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func checkId(_ id: String) -> Bool {
        return id.contains("@") && id.contains(".")
    }
    
    private func checkPw(_ pw: String) -> Bool {
        return pw.count >= 8
    }
    
    private func loginTypeChange() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        tv_id.setBottomBorder(color: .systemGray5)
        tv_pwd.setBottomBorder(color: .systemGray5)
    }
    
    private func kakaoLogin() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            kakaoLoginWithApp()
        } else {
            kakaoLoginWithAccount()
        }
    }
    
    private func kakaoLoginWithApp() {
        UserApi.shared.loginWithKakaoTalk{ (oauthToken, error) in
            if let error = error {
                print("kakaoTalkLogin error: \(error)")
            } else {
                print("loginWIthKakaoTalk() sucess.")
                print("token: \(oauthToken?.accessToken)")
                _ = oauthToken
            }
        }
    }
    
    private func kakaoLoginWithAccount() {
        UserApi.shared.loginWithKakaoAccount{ (oauthToken, error) in
            if let error = error {
                print("kakaoAccountLogin error: \(error)")
            } else {
                print("kakaoAccountLogin() sucess.")
                
                _ = oauthToken
            }
        }
    }
    
    private func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                print("google login error: \(error!)")
                return
            }
            print("googleLogin() sucess.")
            print(signInResult)
            
        }
    }
    
    private func appleLogin() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
}

extension LoginView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomBorder(color: common.commonBasicColor)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setBottomBorder(color: UIColor.systemGray5)
    }
}

extension LoginView: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            case let appleIdCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIdCredential.user
            let fullName = appleIdCredential.fullName
            let email = appleIdCredential.email
            
            let identityToken = appleIdCredential.identityToken
            let authorizationCode = appleIdCredential.authorizationCode
            
            print("appleLogin() sucess.")
            
            // 로그인 성공 후 present
            
        case let passwordCredential as ASPasswordCredential:
            
            let userIdentifier = passwordCredential.user
            let password = passwordCredential.password
            
            // 로그인 성공 후 present
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        print("apple login error: \(error)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
    
}
