//
//  ChattingListView.swift
//  Chatting
//
//  Created by 박제형 on 1/6/25.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

class ChattingListView: UIViewController {
    
    let common = Common()
    
    let disposeBag = DisposeBag()
    
    var chattingList: [ChattingList] = []
    var filteredChattingList: [ChattingList] = []
    var searchMode: Bool = false
    
    let rootFlexView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "채팅"
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "web-hoduchat_ic_top_seh")?.resized(newWidth: 30), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var addChattingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "web-hoduchat_ic_top_frdadd")?.resized(newWidth: 30), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let searchArea = UIView()
    
    private let searchTextfield: UITextField = {
        let textfield = UITextField()
        //textfield.textFieldSetting()
        textfield.backgroundColor = .systemGray5
        textfield.layer.cornerRadius = 10
        textfield.clearButtonMode = .whileEditing
        textfield.placeholder = "검색어를 입력해주세요."
        return textfield
    }()
    
    private lazy var searchCancelButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var chattingListTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ChattingListCell.self, forCellReuseIdentifier: ChattingListCell.identifier)
        return tableView
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
        
        setupNavigationBarButton()
    }
    
    private func setupNavigationBarButton() {
        
        let addChatting = UIBarButtonItem(customView: addChattingButton)
        let search = UIBarButtonItem(customView: searchButton)
        
        navigationItem.rightBarButtonItems = [addChatting, search]
        
        setupButtonAction()
    }
    
    private func setupButtonAction() {
        
        searchButton.addAction(UIAction { _ in
            self.searchMode.toggle()
            if self.searchMode {
                self.searchArea.flex.height(40).marginVertical(4)
            } else {
                self.searchArea.flex.height(0).marginVertical(0)
            }
            self.markDirty()
        }, for: .touchUpInside)
        
        addChattingButton.addAction(UIAction { _ in
            let addChattingVC = AddChattingView()
            let navigationController = UINavigationController(rootViewController: addChattingVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true)
        }, for: .touchUpInside)
        
        searchCancelButton.addAction(UIAction { _ in
            self.view.endEditing(true)
            self.searchTextfield.text = ""
            self.searchMode = false
            self.searchArea.flex.height(0).marginVertical(0)
            self.markDirty()
            self.filteredChattingList.removeAll()
            self.chattingListTableView.reloadData()
        }, for: .touchUpInside)
        
        searchTextfield.rx.text
            .orEmpty
            .skip(0)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                self.filteredChattingList = self.chattingList.filter { $0.name.lowercased().contains(text.lowercased()) }
                self.chattingListTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        initUI()
    }
    
    private func initUI() {
        
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.paddingHorizontal(16).define { flex in
            flex.addItem(searchArea).direction(.row).height(0).define { searchArea in
                searchArea.addItem(searchTextfield).grow(1)
                searchArea.addItem(searchCancelButton).size(40)
            }
            flex.addItem(chattingListTableView).grow(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
    }
    
    private func markDirty() {
        
        UIView.animate(withDuration: 0.3) {
            self.searchArea.flex.markDirty()
            self.rootFlexView.flex.layout()
        }
    }
    
    func dataParsing() {
        
        let url = Bundle.main.url(forResource: "ChattingList", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let info = try? JSONDecoder().decode(ChattingListModel.self, from: data!)
        
        chattingList = info!.chattingList
    }
}

extension ChattingListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChattingList.isEmpty ? chattingList.count : filteredChattingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChattingListCell.identifier, for: indexPath) as! ChattingListCell
        
        let position = filteredChattingList.isEmpty ? chattingList[indexPath.row] : filteredChattingList[indexPath.row]
        print(position.profileImage.count)
        //cell.profileImage.image = UIImage(named: position.profileImage ?? "web-hoduchat_user_square")
        cell.nameLabel.text = position.name
        cell.lastChatLable.text = position.lastChat
        cell.lastChatTimeLabel.text = position.lastChatTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let position = filteredChattingList.isEmpty ? chattingList[indexPath.row] : filteredChattingList[indexPath.row]
        
        let chattingRoomVC = ChattingRoomView()
        chattingRoomVC.chatRoomName = position.name
        //chattingRoomVC.proFileImage = position.profileImage ?? "web-hoduchat_user_square"
        let navigationController = UINavigationController(rootViewController: chattingRoomVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
}
