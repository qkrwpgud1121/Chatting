//
//  SettingView.swift
//  Chatting
//
//  Created by 박제형 on 1/14/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class SettingView: UIViewController {
    
    let common = Common()
    
    let rootFlexContainer = UIView()
    let contentView = UIView()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.title = "설정"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupButtonAction()
    }
    
    func setupButtonAction() {
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        logoutButton.addAction(UIAction { _ in
            self.view.window?.rootViewController?.dismiss(animated: true)
        }, for: .touchUpInside)
        
        initUI()
    }
    
    func initUI() {
        
        rootFlexContainer.backgroundColor = .white
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.define { flex in
            flex.addItem(contentView).direction(.column).marginHorizontal(16).define { content in
                
                content.addItem(logoutButton).height(46)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all()
        rootFlexContainer.flex.layout()
        
        contentView.pin.all(view.pin.safeArea)
        contentView.flex.layout()
    }
}
