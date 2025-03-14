//
//  AddChatting.swift
//  Chatting
//
//  Created by 박제형 on 1/23/25.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa
import RxKeyboard

class AddChattingView: UIViewController {
    
    let common = Common()
    
    let disposeBag = DisposeBag()
    
    let rootFlexView = UIView()
    let contentView = UIView()
    let scrollView = UIScrollView()
    
    var friendsList: [AddFriends] = []
    
    var members: [AddFriends] = []
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.systemGray3, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 15
        //textField.textFieldSetting()
        return textField
    }()
    
    private lazy var friendsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(AddChattingCell.self, forCellReuseIdentifier: AddChattingCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.rx.text
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                
            })
            .disposed(by: disposeBag)
        
        initUI()
    }
    
    private func initUI() {
        rootFlexView.backgroundColor = .white
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.paddingHorizontal(16).define { flex in
            
            flex.addItem(scrollView).direction(.row).height(0).define { scrollView in
                scrollView.addItem(contentView).direction(.row)
            }
            flex.addItem(searchTextField).height(40).marginTop(8)
            flex.addItem(friendsListTableView).grow(1)
            
        }
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: confirmButton)
        self.navigationItem.title = "대화상대 선택"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        componentAction()
    }
    
    private func componentAction() {
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        confirmButton.addAction(UIAction { _ in
            
        }, for: .touchUpInside)
        
        dataParsing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        flexLayout()
    }
    
    private func flexLayout() {
        rootFlexView.pin.top(view.pin.safeArea).bottom().left().right()
        rootFlexView.flex.layout()
        
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustWidth)
        
        scrollView.contentSize = contentView.frame.size
    }
    
    func topAddMembers(row data: AddFriends) {
        
        UIView.animate(withDuration: 0.3) {
            
            if self.members.count > 0 {
                
                self.contentView.flex.direction(.row).define { contentView in
                    let memberView: UIView = {
                        let view = UIView()
                        view.layer.name = data.userId
                        view.tag = Int(data.userId)!
                        view.isUserInteractionEnabled = true
                        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewClick)))
                        return view
                    }()
                    
                    memberView.flex.direction(.column).alignItems(.center).marginRight(8).define { memberInfo in
                        
                        let profileImageView: UIImageView = {
                            let imageView = UIImageView()
                            imageView.image = UIImage(named: data.profileImage ?? "web-hoduchat_user_square")
                            imageView.layer.cornerRadius = 15
                            imageView.clipsToBounds = true
                            return imageView
                        }()
                        
                        let nameLabel: UILabel = {
                            let label = UILabel()
                            label.font = UIFont.systemFont(ofSize: 12)
                            label.text = data.name
                            return label
                        }()
                        
                        memberInfo.addItem(profileImageView).size(40)
                        memberInfo.addItem(nameLabel).marginTop(4)
                    }
                    
                    contentView.addItem(memberView)
                    
                }
                
                self.scrollView.flex.height(60)
                self.scrollView.flex.markDirty()
                self.scrollView.flex.layout()
                
                self.flexLayout()
            }
        }
        
        changeConfirmButtonText()
    }
    
    func topDeleteMembers(row data: AddFriends) {
        
        guard let deleteImageView = self.view.viewWithTag(Int(data.userId)!) else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            deleteImageView.alpha = 0
            deleteImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            deleteImageView.removeFromSuperview()
            
            self.scrollView.flex.markDirty()
            self.scrollView.flex.layout()
        }
        
        if self.members.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.scrollView.flex.height(0)
                self.scrollView.flex.markDirty()
                self.scrollView.flex.layout()
                
                self.flexLayout()
            }
        }
        
        changeConfirmButtonText()
    }
    
    @objc func viewClick(_ sender: UITapGestureRecognizer){
        guard let tappedView = sender.view else { return }
        
        let memberIndex = friendsList.firstIndex(where: { $0.userId == tappedView.layer.name})
        
        let indexPath = IndexPath(row: memberIndex!, section: 0)
        let cell = friendsListTableView.cellForRow(at: indexPath) as? AddChattingCell
        cell?.checkBoxButton.setImage(UIImage(systemName: "circle"), for: .normal)
        
        friendsList[memberIndex!].selected = false
        
        // UI에서 뷰 제거
        UIView.animate(withDuration: 0.3, animations: {
            tappedView.alpha = 0
            tappedView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { _ in
            tappedView.removeFromSuperview()
            
            // 레이블도 함께 제거
            if let label = tappedView.superview?.subviews.first(where: { $0 is UILabel }) {
                label.removeFromSuperview()
            }
            
            // Flexbox 레이아웃 업데이트
            self.scrollView.flex.markDirty()
            self.scrollView.flex.layout()
        }
        
        self.members.removeAll { Int($0.userId) == tappedView.tag}
        
        if self.members.count == 0 {
            UIView.animate(withDuration: 0.3) {
                self.scrollView.flex.height(0)
                self.scrollView.flex.markDirty()
                self.scrollView.flex.layout()
                self.flexLayout()
            }
        }
        
        changeConfirmButtonText()
    }
    
    func changeConfirmButtonText() {
        
        let title = members.count == 0 ? "확인" : "\(members.count) 확인"
        let titleColor: UIColor = members.count == 0 ? .systemGray : .black
        
        confirmButton.setTitle(title, for: .normal)
        confirmButton.setTitleColor(titleColor, for: .normal)
    }
    
    func dataParsing() {
        
        let url = Bundle.main.url(forResource: "AddChatting", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let info = try? JSONDecoder().decode(AddChattingModel.self, from: data!)
        
        friendsList = info!.Friends
        
    }
}

extension AddChattingView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddChattingCell.identifier, for: indexPath) as! AddChattingCell
        
        friendsList[indexPath.row].selected = false
        let data = friendsList[indexPath.row]
        
        cell.position = indexPath.row
        
        cell.profileImageView.image = UIImage(named: data.profileImage ?? "web-hoduchat_user_square")
        cell.nameLabel.text = data.name
        cell.checkBoxButton.layer.name = data.userId
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddChattingCell
        
        cell.checkBoxButton.layer.name = friendsList[indexPath.row].userId
        
        if friendsList[indexPath.row].selected! {
            friendsList[indexPath.row].selected! = false
            cell.checkBoxButton.setImage(UIImage(systemName: "circle"), for: .normal)
            members.removeAll { $0.name == friendsList[indexPath.row].name}
            topDeleteMembers(row: friendsList[indexPath.row])
        } else {
            friendsList[indexPath.row].selected! = true
            cell.checkBoxButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            members.append(friendsList[indexPath.row])
            topAddMembers(row: friendsList[indexPath.row])
        }
    }
    
}
