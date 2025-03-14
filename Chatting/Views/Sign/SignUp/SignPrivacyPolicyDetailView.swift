//
//  SignPrivacyPolicyView.swift
//  Chatting
//
//  Created by 박제형 on 2/14/25.
//

import UIKit
import FlexLayout
import PinLayout

enum privacyPolicyType: String {
    case use = "userjoin_provision"
    case userInfo = "userjoin_personal_info"
}

class SignPrivacyPolicyDetailView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var type: privacyPolicyType = .use
    var onDismiss: ((Bool) -> Void)?
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark", leading: 10))
        button.tintColor = .black
        return button
    }()
    
    let lbl_title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let btn_agree: UIButton = {
        let button = UIButton()
        button.setTitle("동의", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor(hexCode: "769EFF")
        return button
    }()
    
    private let tv_detail: UITextView = {
        let textView = UITextView()
        return textView
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
        
        btn_agree.addAction(UIAction { [weak self] _ in
            self?.onDismiss?(true)
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        lbl_title.text = type == .use ? "이용 약관" : "개인정보 수집 및 이용"
        readTextFromFile( filename: type == .use ? privacyPolicyType.use.rawValue : privacyPolicyType.userInfo.rawValue ) { [weak self] text in
            self?.tv_detail.text = text!
        }
        
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        scrollView.showsVerticalScrollIndicator = false
        
        rootFlexView.flex.paddingHorizontal(32).define { flex in
            flex.addItem(lbl_title).height(50)
            flex.addItem(tv_detail)
            flex.addItem(btn_agree).height(54)
        }
    }
    
    func readTextFromFile(filename: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.global().async {
            if let filePath = Bundle.main.path(forResource: filename, ofType: "txt") {
                do {
                    let content = try String(contentsOfFile: filePath, encoding: .utf8)
                    DispatchQueue.main.async {
                        completion(content)
                    }
                } catch {
                    print("Error reading file: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } else {
                print("File not found")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        lbl_title.pin.top()
        btn_agree.pin.bottom()
        tv_detail.pin.verticallyBetween(lbl_title, and: btn_agree).marginVertical(16)
    }
}
