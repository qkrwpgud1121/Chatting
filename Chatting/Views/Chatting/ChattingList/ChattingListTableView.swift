////
////  ChattingListTableView.swift
////  Chatting
////
////  Created by 박제형 on 1/13/25.
////
//
//import Foundation
//import UIKit
//
//class ChattingListTableView: UIView {
//    
//    let tableView = UITableView()
//    let chattingListCell = ChattingListCell()
//    
//    var chattingListModel: [ChattingListModel] = []
//    
//    init() {
//        super.init(frame: .zero)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.estimatedRowHeight = 10
//        tableView.register(ChattingListCell.self, forCellReuseIdentifier: ChattingListCell.identifier)
//        addSubview(tableView)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(methods: [ChattingListModel]) {
//        self.chattingListModel = methods
//        tableView.reloadData()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        tableView.pin.all()
//    }
//}
//
//extension ChattingListTableView: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        chattingListModel.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ChattingListCell.identifier, for: indexPath) as! ChattingListCell
//        //cell.configure(method: chattingListModel[indexPath.row])
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
