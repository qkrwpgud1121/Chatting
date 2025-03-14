//
//  ChattingRoomFileBoxView.swift
//  Chatting
//
//  Created by 박제형 on 2/26/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomFileBoxView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "사진/동영상", at: 0, animated: true)
        segment.insertSegment(withTitle: "파일", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        segment.selectedSegmentTintColor = .clear
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray.cgColor,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
        ], for: .normal)
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(cgColor: common.commonBasicColor.cgColor),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
        ], for: .selected)
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segment.addTarget(self, action: #selector(tapChanged), for: .valueChanged)
        return segment
    }()
    
    private lazy var underLine: UIView = {
        let view = UIView()
        view.backgroundColor = common.commonBasicColor
        return view
    }()
    
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
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.title = ""
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
        
        initUI()
    }
    
    private func initUI() {
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        rootFlexView.backgroundColor = .white
        
        segmentedControl.backgroundColor = .white
        segmentedControl.selectedSegmentIndex = 0
        
        
        rootFlexView.flex.define { flex in
            flex.addItem(segmentedControl).height(40)
            flex.addItem(underLine).width(view.frame.size.width / 2).height(2)
            flex.addItem(cv_fileBox)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        cv_fileBox.pin.below(of: underLine).bottom().horizontally()
    }
    
    @objc func tapChanged() {
        let underlineWidth = view.frame.size.width / 2
        
        let underlineXPosition = CGFloat(segmentedControl.selectedSegmentIndex) * underlineWidth
        
        var segueId: String = ""
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            segueId = "ChattingRoomFileBoxView"
        case 1:
            segueId = "ChattingRoomFileBoxView"
        default:
            break
        }
        
        UIView.animate(withDuration: 0.3) {
            self.underLine.frame.origin.x = underlineXPosition
        }
        
    }
}

extension ChattingRoomFileBoxView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingRoomFileBoxCell.identifier, for: indexPath) as! ChattingRoomFileBoxCell
        
        cell.configure()
        
        return cell
    }
    
}

extension ChattingRoomFileBoxView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3 - 4
        return CGSize(width: size, height: size)
    }
}
