//
//  FriendListView.swift
//  Chatting
//
//  Created by 박제형 on 1/6/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    
    var favorite: Bool!
    var userName: String!
    var profileImageName: String!
    var status: String!
    var myProfile: Bool? = false
}

class FriendListView: UIViewController {
    
    let common = Common()
    
    let rootFlexContainer = UIView()
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let contentView = UIView()
    
    var birthDayFriends: [BirthdayFriend] = []
    var favoriteFriends: [FavoriteFriend] = []
    var friends: [Friends] = []
    
    let updateProfileInfo: [String: String] = ["진환": "1", "재욱": "2", "종수": "3", "상운": "4", "동준": "5", "준관": "6", "재경": "7", "미나": "8", "승환": "9", "유진": "10"]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구"
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var searchFriendButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "magnifyingglass", leading: 5.0))
        button.tintColor = .black
        return button
    }()
    
    private lazy var addFriendButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "person.badge.plus", leading: 5.0))
        button.tintColor = .black
        return button
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "gear", leading: 5.0))
        button.tintColor = .black
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "167")
        return imageView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "박제형"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let updateProfileScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let updateProfileContentView = UIView()
    private let updateProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "업데이트한 프로필"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let birthdayFriendsContentView = UIView()
    private let birthdayFriendLabel: UILabel = {
        let label = UILabel()
        label.text = "생일인 친구"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let favoriteFriendsContentView = UIView()
    private let favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let friendsContentView = UIView()
    private let friendLabel: UILabel = {
        let label = UILabel()
        label.text = "친구"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let separatorView3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let separatorView4: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataParsing()
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupRightBarButtons()
    }
    
    private func setupRightBarButtons() {
        let setting = UIBarButtonItem(customView: settingButton)
        let addFriend = UIBarButtonItem(customView: addFriendButton)
        let search = UIBarButtonItem(customView: searchFriendButton)
        
        navigationItem.rightBarButtonItems = [setting, addFriend, search]
        
        setupButtonAction()
    }
    
    func setupButtonAction() {
        
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(profileTapped(sender: )))
        tapGesture.userName = "박제형"
        tapGesture.profileImageName = "167"
        tapGesture.myProfile = true
        profileImageView.addGestureRecognizer(tapGesture)
        
        searchFriendButton.addAction(UIAction { _ in
            let searchFriendsVC = SearchFriendsView()
            let navigationController = UINavigationController(rootViewController: searchFriendsVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }, for: .touchUpInside)
        
        addFriendButton.addAction(UIAction { _ in
            print("button tapped!")
        }, for: .touchUpInside)
        
        settingButton.addAction(UIAction { _ in
            let settingVC = SettingView()
            let navigationController = UINavigationController(rootViewController: settingVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }, for: .touchUpInside)
        
        initUI()
    }
    
    func initUI() {
        
        view.addSubview(rootFlexContainer)
        rootFlexContainer.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.direction(.column).marginHorizontal(16).define { flex in
            
            flex.addItem().direction(.row).alignItems(.center).marginVertical(16).height(64).define { myProfile in
                myProfile.addItem(profileImageView).width(65).height(65).marginRight(16)
                myProfile.addItem(profileNameLabel)
            }
            
            flex.addItem(separatorView).height(0.5).marginBottom(10)
            
            flex.addItem(updateProfileLabel).marginBottom(10)
            flex.addItem(updateProfileScrollView).direction(.row).define { updateScroll in
                
                updateScroll.addItem(updateProfileContentView).direction(.row).define { updateContentView in
                    
                    for (name, profileImage) in updateProfileInfo {
                        
                        let profileInfoView = UIView()
                        
                        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(profileTapped(sender:)))
                        tapGesture.userName = name
                        tapGesture.profileImageName = profileImage
                        profileInfoView.addGestureRecognizer(tapGesture)
                        
                        profileInfoView.flex.direction(.column).alignItems(.center).define { info in
                            
                            let updateProfileImageView = UIImageView()
                            updateProfileImageView.image = UIImage(named: profileImage)
                            updateProfileImageView.layer.cornerRadius = 20
                            updateProfileImageView.clipsToBounds = true
                            
                            let updateProfileNameLabel = UILabel()
                            updateProfileNameLabel.text = name
                            updateProfileNameLabel.font = .systemFont(ofSize: 12, weight: .regular)
                            
                            info.addItem(updateProfileImageView).size(50).marginBottom(8)
                            info.addItem(updateProfileNameLabel)
                        }
                        
                        updateContentView.addItem(profileInfoView).marginRight(10)
                    }
                }
            }
            
            flex.addItem(separatorView2).height(0.5).marginVertical(10)
            
            flex.addItem(birthdayFriendLabel).marginBottom(10)
            flex.addItem(birthdayFriendsContentView).define { birthdayContentView in
                
                for birthDayPersons in birthDayFriends {
                    
                    let birthDayPersonProfiles = UIView()
                    
                    let favorite = birthDayPersons.favorite
                    let userName = birthDayPersons.name
                    let profileImage = birthDayPersons.profileImage ?? "web-hoduchat_user_square"
                    let birthDate = birthDayPersons.birthDate
                    
                    
                    let profileTapGesture = CustomTapGestureRecognizer(target: self, action: #selector(profileTapped(sender:)))
                    profileTapGesture.favorite = favorite
                    profileTapGesture.userName = userName
                    profileTapGesture.profileImageName = profileImage
                    birthDayPersonProfiles.addGestureRecognizer(profileTapGesture)
                    
                    birthDayPersonProfiles.flex.addItem().direction(.row).alignItems(.center).marginBottom(8).define { stackView in
                        
                        let birthDayProfileImageView: UIImageView = {
                            let imageView = UIImageView()
                            imageView.image = UIImage(named: profileImage)
                            imageView.layer.cornerRadius = 20
                            imageView.clipsToBounds = true
                            return imageView
                        }()
                        
                        let birthDayProfileNameLabel: UILabel = {
                            let label = UILabel()
                            label.text = userName
                            label.font = .systemFont(ofSize: 15, weight: .medium)
                            return label
                        }()
                        
                        let birthDayProfileBirthdayLabel: UILabel = {
                            let label = UILabel()
                            label.text = birthDate
                            label.font = .systemFont(ofSize: 12, weight: .light)
                            return label
                        }()
                        
                        stackView.addItem(birthDayProfileImageView).size(50).marginRight(8)
                        stackView.addItem().direction(.column).define { textLable in
                            textLable.addItem(birthDayProfileNameLabel).marginBottom(4)
                            textLable.addItem(birthDayProfileBirthdayLabel)
                        }
                    }
                    birthdayContentView.addItem(birthDayPersonProfiles)
                }
            }
            
            flex.addItem(separatorView3).height(0.5).marginVertical(10)
            
            flex.addItem(favoriteLabel).marginBottom(10)
            flex.addItem(favoriteFriendsContentView).define { favoriteFriendsContentView in
                
                for favoriteFriends in favoriteFriends {
                    
                    let favoritePersonProfiles = UIView()
                    
                    let favorite = favoriteFriends.favorite
                    let name = favoriteFriends.name
                    let profileImageName = favoriteFriends.profileImage ?? "noProfiweb-web-hoduchat_user_square"
                    let status = favoriteFriends.status
                    
                    let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(profileTapped(sender: )))
                    tapGesture.favorite = favorite
                    tapGesture.userName = name
                    tapGesture.profileImageName = profileImageName
                    tapGesture.status = status
                    favoritePersonProfiles.addGestureRecognizer(tapGesture)
                    
                    favoritePersonProfiles.flex.addItem().direction(.row).alignItems(.center).marginBottom(8).define { stackView in
                        
                        let favoriteProfileImageView: UIImageView = {
                            let imageView = UIImageView()
                            imageView.image = UIImage(named: profileImageName)
                            imageView.layer.cornerRadius = 20
                            imageView.clipsToBounds = true
                            return imageView
                        }()
                        
                        let favoriteProfileNameLabel: UILabel = {
                            let label = UILabel()
                            label.text = name
                            label.font = .systemFont(ofSize: 15, weight: .medium)
                            return label
                        }()
                        
                        let favoriteProfileStatusLabel: UILabel = {
                            let label = UILabel()
                            label.text = status
                            label.font = .systemFont(ofSize: 12, weight: .light)
                            return label
                        }()
                        
                        
                        stackView.addItem(favoriteProfileImageView).size(50).marginRight(8)
                        stackView.addItem().direction(.column).define { textLable in
                            textLable.addItem(favoriteProfileNameLabel).marginBottom(4)
                            textLable.addItem(favoriteProfileStatusLabel)
                        }
                    }
                    favoriteFriendsContentView.addItem(favoritePersonProfiles)
                }
            }
            
            flex.addItem(separatorView4).height(0.5).marginVertical(10)
            
            flex.addItem(friendLabel).marginBottom(10)
            flex.addItem(friendsContentView).define { friendsContentView in
                
                for _ in 0..<2 {
                    
                    for friends in friends {
                        
                        let friendsProfiles = UIView()
                        
                        let favorite = friends.favorite
                        let name = friends.name
                        let profileImageName = friends.profileImage ?? "web-hoduchat_user_square"
                        let status = friends.status
                        
                        let tapGesture = CustomTapGestureRecognizer(target: self, action: #selector(profileTapped(sender: )))
                        tapGesture.favorite = favorite
                        tapGesture.userName = name
                        tapGesture.profileImageName = profileImageName
                        tapGesture.status = status
                        friendsProfiles.addGestureRecognizer(tapGesture)
                        
                        friendsProfiles.flex.addItem().direction(.row).alignItems(.center).marginBottom(8).define { stackView in
                            
                            let friendsProfileImageView: UIImageView = {
                                let imageView = UIImageView()
                                imageView.image = UIImage(named: profileImageName)
                                imageView.layer.cornerRadius = 20
                                imageView.clipsToBounds = true
                                return imageView
                            }()
                            
                            let friendsProfileNameLabel: UILabel = {
                                let label = UILabel()
                                label.text = name
                                label.font = .systemFont(ofSize: 15, weight: .medium)
                                return label
                            }()
                            
                            let friendsProfileStatusLabel: UILabel = {
                                let label = UILabel()
                                label.text = status
                                label.font = .systemFont(ofSize: 12, weight: .light)
                                return label
                            }()
                            
                            stackView.addItem(friendsProfileImageView).size(50).marginRight(8)
                            stackView.addItem().direction(.column).define { textLable in
                                textLable.addItem(friendsProfileNameLabel).marginBottom(4)
                                textLable.addItem(friendsProfileStatusLabel)
                            }
                        }
                        friendsContentView.addItem(friendsProfiles)
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        
        scrollView.pin.all()
        contentView.pin.all()
        
        updateProfileScrollView.pin.all()
        updateProfileContentView.pin.all()
        
        contentView.flex.layout(mode: .adjustHeight)
        updateProfileContentView.flex.layout(mode: .adjustWidth)
        
        scrollView.contentSize = contentView.frame.size
        updateProfileScrollView.contentSize = updateProfileContentView.frame.size
    }
    
    @objc func profileTapped(sender: CustomTapGestureRecognizer) {
        
        let profileDetailVC = ProfileDetail()
        
        profileDetailVC.favorite = sender.favorite
        profileDetailVC.userName = sender.userName
        profileDetailVC.profileImageName = sender.profileImageName
        profileDetailVC.myProfile = sender.myProfile
        profileDetailVC.status = sender.status
        
        let navigationController = UINavigationController(rootViewController: profileDetailVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
        
    }
    
    func dataParsing() {
        
        let url = Bundle.main.url(forResource: "BirthdayFriend", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let info = try? JSONDecoder().decode(FriendListModel.self, from: data!)
        
        
        birthDayFriends = info!.birthdayFriends
        favoriteFriends = info!.favoriteFriends
        friends = info!.friends
    }
    
}
