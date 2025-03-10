//
//  ProfileDetail.swift
//  Chatting
//
//  Created by 박제형 on 1/8/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class ProfileDetail: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    let backGroundImageView = UIImageView()
    let backGroundAlpha = UIView()
    
    var favorite: Bool!
    var userName: String!
    var profileImageName: String!
    var status: String!
    var myProfile: Bool? = false
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark", leading: 10))
        button.tintColor = .white
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteImage: String = favorite ? "star.fill" : "star"
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: favoriteImage, leading: 10))
        button.tintColor = favorite ? .yellow : .white
        return button
    }()
    
    private lazy var friendStatusButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "ellipsis", leading: 10))
        button.tintColor = .white
        return button
    }()
    
    private lazy var myChat: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "message.fill", placement: "top", imagePadding: 15))
        button.setTitle("나와의 채팅", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.tintColor = .white
        button.sizeToFit()
        return button
    }()
    
    private lazy var editProfile: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "pencil", placement: "top", imagePadding: 15))
        button.setTitle("프로필 편집", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.tintColor = .white
        button.sizeToFit()
        return button
    }()
    
    private lazy var friendChat: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "message.fill", placement: "top", imagePadding: 15))
        button.setTitle("1:1 채팅", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.tintColor = .white
        button.sizeToFit()
        return button
    }()
    
    private lazy var faceTime: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "video.fill", placement: "top", imagePadding: 15))
        button.setTitle("Face Time", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.tintColor = .white
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        if !myProfile! {
            let statusButton = UIBarButtonItem(customView: friendStatusButton)
            let favoriteButton = UIBarButtonItem(customView: favoriteButton)
            self.navigationItem.rightBarButtonItems = [statusButton, favoriteButton]
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupButtonAction()
    }
    
    func setupButtonAction() {
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        favoriteButton.addAction(UIAction { _ in
            self.favorite.toggle()
            let favoriteImage: String = self.favorite ? "star.fill" : "star"
            let tintColor: UIColor = self.favorite ? .yellow : .white
            self.favoriteButton.setImage(UIImage(systemName: favoriteImage), for: .normal)
            self.favoriteButton.tintColor = tintColor
        }, for: .touchUpInside)
        
        friendStatusButton.menu = UIMenu( children: [
            UIAction(title: "친구 숨김", handler: {_ in }),
            UIAction(title: "친구 삭제", handler: {_ in }),
            UIAction(title: "친구 차단", handler: {_ in })
        ])
        friendStatusButton.showsMenuAsPrimaryAction = true
        
        myChat.addAction(UIAction { _ in
            self.chattingRoom()
        }, for: .touchUpInside)
        
        editProfile.addAction(UIAction { _ in
            print("Edit Profile")
        }, for: .touchUpInside)
        
        friendChat.addAction(UIAction { _ in
            self.chattingRoom()
        }, for: .touchUpInside)
        
        faceTime.addAction(UIAction { _ in
            print("Face Time")
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        rootFlexView.addSubview(backGroundImageView)
        backGroundImageView.flex.isIncludedInLayout = false
        backGroundImageView.addSubview(backGroundAlpha)
        
        backGroundImageView.image = UIImage(named: "exampleImage")
        backGroundAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        profileNameLabel.text = userName
        profileImageView.image = UIImage(named: profileImageName)
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImageDetail)))
        statusLabel.text = status
        
        rootFlexView.flex.define { flex in
            
            flex.addItem(backGroundAlpha).direction(.columnReverse).define { bottomSheet in
                
                bottomSheet.addItem().direction(.row).justifyContent(.spaceAround).backgroundColor(.clear).height(150).define { bottomEvent in
                    if myProfile! {
                        bottomEvent.addItem(myChat)
                        bottomEvent.addItem(editProfile)
                    } else {
                        bottomEvent.addItem(friendChat)
                        bottomEvent.addItem(faceTime)
                    }
                }
                
                bottomSheet.addItem(separatorView).height(0.5).marginHorizontal(16)
                
                bottomSheet.addItem().direction(.column).alignItems(.center).marginBottom(32).define { profile in
                    profile.addItem(profileImageView).marginBottom(8).height(100).width(100)
                    profile.addItem(profileNameLabel).marginBottom(8)
                    profile.addItem(statusLabel)
                }
            }
        }
    }
    
    @objc func profileImageDetail() {
        
        let profileImageViewVC = ProfileImageView()
        profileImageViewVC.profileImageName = self.profileImageName
        let navigationController = UINavigationController(rootViewController: profileImageViewVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        rootFlexView.flex.layout()
        
        backGroundImageView.pin.all()
        
        backGroundAlpha.pin.all()
        backGroundAlpha.flex.layout()
    }
    
    private func chattingRoom() {
        
        let chattingRoomVC = ChattingRoomView()
        chattingRoomVC.chatRoomName = self.userName
        chattingRoomVC.proFileImage = self.profileImageName
        let navigationController = UINavigationController(rootViewController: chattingRoomVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
}


