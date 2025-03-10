//
//  SearchFriendsView.swift
//  Chatting
//
//  Created by 박제형 on 2/11/25.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class SearchFriendsView: UIViewController {
    
    let common = Common()
    let disposeBag = DisposeBag()
    
    var friendsList: [AddFriends] = []
    var filteredFriendsList: [AddFriends] = []
    
    let rootFlexView = UIView()
    
    let searchBar: UITextField = {
        let textField = UITextField()
        //textField.textFieldSetting()
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 10
        textField.placeholder = "이름, 연락처등 으로 검색"
        return textField
    }()
    
    private lazy var friendsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(SearchFriendsCell.self, forCellReuseIdentifier: SearchFriendsCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataParsing()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.top(view.pin.safeArea).bottom().left().right()
        rootFlexView.flex.layout()
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.title = "친구 검색"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setAction()
    }
    
    private func setAction() {
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                self.filteredFriendsList = self.friendsList.filter({ $0.name.lowercased().contains(text.lowercased()) })
                self.friendsTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        initUI()
    }
    
    private func initUI() {
        
        rootFlexView.backgroundColor = .white
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.paddingHorizontal(16).define { flex in
            flex.addItem(searchBar).height(40).marginVertical(4)
            flex.addItem(friendsTableView).grow(1)
        }
    }
    
    private func dataParsing() {
        
        let url = Bundle.main.url(forResource: "AddChatting", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let info = try? JSONDecoder().decode(AddChattingModel.self, from: data!)
        
        friendsList = info!.Friends
    }
}

extension SearchFriendsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredFriendsList.isEmpty {
            return friendsList.count
        } else {
            return filteredFriendsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendsCell.identifier, for: indexPath) as! SearchFriendsCell
        cell.selectionStyle = .none
        if filteredFriendsList.isEmpty {
            cell.profileImage.image = UIImage(named: friendsList[indexPath.row].profileImage ?? "web-hoduchat_user_square")
            cell.nameLabel.text = friendsList[indexPath.row].name
        } else {
            cell.profileImage.image = UIImage(named: filteredFriendsList[indexPath.row].profileImage ?? "web-hoduchat_user_square")
            cell.nameLabel.text = filteredFriendsList[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let profileVC = ProfileDetail()
        if filteredFriendsList.isEmpty {
            profileVC.profileImageName = friendsList[indexPath.row].profileImage ?? "web-hoduchat_user_square"
            profileVC.userName = friendsList[indexPath.row].name
        } else {
            profileVC.profileImageName = filteredFriendsList[indexPath.row].profileImage ?? "web-hoduchat_user_square"
            profileVC.userName = filteredFriendsList[indexPath.row].name
        }
        let navigationController = UINavigationController(rootViewController: profileVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
}
