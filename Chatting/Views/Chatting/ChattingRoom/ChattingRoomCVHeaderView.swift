//
//  ChattingRoomCVHeaderView.swift
//  Chatting
//
//  Created by 박제형 on 3/14/25.
//

import UIKit

class ChattingRoomCVHeaderView: UICollectionReusableView {
    
    static let identifier: String = "ChattingRoomCVHeaderView"
    
    private lazy var lb_Date: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lb_Date.frame = bounds
    }
    
    func configure() {
        backgroundColor = .green
        addSubview(lb_Date)
    }
}
