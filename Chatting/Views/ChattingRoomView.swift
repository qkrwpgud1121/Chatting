//
//  ChattingRoomView.swift
//  Chatting
//
//  Created by 박제형 on 1/14/25.
//

import UIKit
import FlexLayout
import PinLayout
import RxSwift
import RxKeyboard

enum modalBottomSheet {
    case fileBox
    case roomSetting
}

class ChattingRoomView: UIViewController, ChattingRoomSettingViewDelegate {
    
    let common = Common()
    
    var chattingMsgList: [ChattingMsgData] = []
    
    let disposeBag = DisposeBag()
    
    let rootFlexContainer = UIView()
    
    var chatRoomName: String = ""
    var proFileImage: String? = ""
    
    var backgroundHexCode: String = "F9E1E2"
    lazy var backgroundColor = UIColor(hexCode: self.backgroundHexCode)
    
    var items: [UIAction] {
        let invite = UIAction(title: "대화상대 초대", handler: { _ in print("invite") })
        let fileBox = UIAction(title: "파일함", handler: { _ in  self.modalBottomSheet(modalType: .fileBox)})
        let roomSetting = UIAction(title: "채팅방 설정", handler: { _ in self.modalBottomSheet(modalType: .roomSetting) })
        let exit = UIAction(title: "채팅방 나가기", handler: { _ in print("exit") })
        let items = [invite, fileBox, roomSetting, exit]
        return items
    }
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var hambergerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "web-hoduchat_ic_chat_menu")?.resized(newWidth: 30), for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.tintColor = .black
        return button
    }()
    
    private let messageListTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let inputContainer = UIView()
    
    private lazy var utilButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 20, image: "plus"))
        button.backgroundColor = .systemGray5
        button.tintColor = .black
        button.layer.cornerRadius = 20
        return button
    }()
    
    private var utilButtonToggle: Bool = false
    
    private let utilView = UIView()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 20
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 20, image: "arrow.up"))
        button.backgroundColor = .systemGray5
        button.tintColor = .black
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        messageListTableView.delegate = self
        messageListTableView.dataSource = self
        messageListTableView.register(ChattingMsgListCell.self, forCellReuseIdentifier: ChattingMsgListCell.identifier)
        messageListTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messageListTableView.contentInset = .zero
        messageListTableView.contentInsetAdjustmentBehavior = .never
        messageListTableView.keyboardDismissMode = .onDrag
        
        dataParsing()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: hambergerButton)
        self.navigationItem.title = chatRoomName
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        componentAction()
    }
    
    private func componentAction() {
        
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        utilButton.addAction(UIAction { _ in
            
            self.utilButtonToggle.toggle()
            UIView.animate(withDuration: 0.3) {
                if self.utilButtonToggle {
                    self.view.endEditing(true)
                    self.utilView.flex.height(300)
                    self.utilView.flex.markDirty()
                    self.rootFlexContainer.flex.layout()
                } else {
                    self.utilView.flex.height(0)
                    self.utilView.flex.markDirty()
                    self.rootFlexContainer.flex.layout()
                }
                
            }
            
        }, for: .touchUpInside)
        
        hambergerButton.menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: items)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                guard let self = self else { return }
                
                if self.utilView.frame.height > 0 {
                    self.utilView.flex.height(0)
                    self.utilView.flex.markDirty()
                    self.inputContainer.flex.marginBottom(height - window.safeAreaInsets.bottom)
                    self.inputContainer.flex.markDirty()
                    self.rootFlexContainer.flex.layout()
                    self.utilButtonToggle = false
                } else if height == 0 && self.utilView.frame.height == 0 {
                    self.inputContainer.flex.marginBottom(height)
                    self.inputContainer.flex.markDirty()
                    self.rootFlexContainer.flex.layout()
                } else  {
                    self.inputContainer.flex.marginBottom(height - window.safeAreaInsets.bottom)
                    self.inputContainer.flex.markDirty()
                    self.rootFlexContainer.flex.layout()
                }
            })
            .disposed(by: disposeBag)
        
        initUI()
    }
    
    private func initUI() {
        
        view.addSubview(rootFlexContainer)
        
        rootFlexContainer.flex.direction(.column).define { flex in
            flex.addItem(messageListTableView).grow(1).backgroundColor(backgroundColor)
            flex.addItem(inputContainer).direction(.row).alignItems(.center).height(60).backgroundColor(.white).define { input in
                input.addItem(utilButton).marginHorizontal(8).size(40)
                input.addItem(textField).grow(1).height(40)
                input.addItem(sendButton).marginHorizontal(8).size(40)
            }
            flex.addItem(utilView).height(0).backgroundColor(.white)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexContainer.pin.all(view.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
    
    func dataParsing() {
        
        let url = Bundle.main.url(forResource: "ChattingMsg", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let info = try? JSONDecoder().decode(ChattingMsgListModel.self, from: data!)
        
        chattingMsgList = info!.data
        
    }
    
    private func sendTime(sendDate: Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(sendDate) / 1000)
        let ls_time = Common.GF_DATE_TO_STRING(date, "a hh:mm", po_locale: Locale(identifier:"ko_KR"))
        
        return ls_time
    }
    
    private func modalBottomSheet(modalType: modalBottomSheet) {
        let modalVC = modalType == .fileBox ? ChattingRoomFileBoxView() : ChattingRoomSettingView()
        modalVC.modalPresentationStyle = .pageSheet
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.largestUndimmedDetentIdentifier = nil
        }
        
        if let settingVC = modalVC as? ChattingRoomSettingView {
            settingVC.delegate = self
            settingVC.chattingRoomName = chatRoomName
            settingVC.backgroundHexCode = backgroundHexCode
        }
        
        self.present(modalVC, animated: true)
    }
    
    func didChangeBackgroundColor(_ color: UIColor) {
        rootFlexContainer.backgroundColor = color
        messageListTableView.backgroundColor = color
        rootFlexContainer.flex.markDirty()
    }
    
}

extension ChattingRoomView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattingMsgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChattingMsgListCell.identifier, for: indexPath) as! ChattingMsgListCell
        
        let userId = cell.userId
        
        let position = indexPath.row
        
        var message = chattingMsgList[position]
        
        let newIndex = chattingMsgList.count - position - 1
        
        let profile = proFileImage ?? "web-hoduchat_user_square"
        
        if newIndex > 0  && sendTime(sendDate: message.send_date) == sendTime(sendDate: chattingMsgList[position + 1].send_date) && message.user_id == chattingMsgList[position + 1].user_id {
            
            message.group = true
        }
        
        if position > 0 && sendTime(sendDate:message.send_date) == sendTime(sendDate:chattingMsgList[position - 1].send_date) && message.user_id == chattingMsgList[position - 1].user_id{
            message.timeStamp = false
        }
        
        message.own = userId == message.user_id
        
        cell.backgroundColor = .clear
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        cell.configure(with: message, profile: profile)
        
        return cell
    }
    
    
}
