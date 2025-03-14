//
//  ChattingRoomFileBoxView.swift
//  Chatting
//
//  Created by 박제형 on 2/26/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomGalleryView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    private lazy var cv_fileBox: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChattingRoomFileBoxCell.self, forCellWithReuseIdentifier: ChattingRoomFileBoxCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    private func initUI() {
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        rootFlexView.backgroundColor = .white
        
        rootFlexView.flex.define { flex in
            flex.addItem(cv_fileBox)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        cv_fileBox.pin.all()
    }
    
}

extension ChattingRoomGalleryView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingRoomFileBoxCell.identifier, for: indexPath) as! ChattingRoomFileBoxCell
        
        cell.configure()
        
        return cell
    }
    
}

extension ChattingRoomGalleryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 2 - 4
        return CGSize(width: size, height: size)
    }
}
