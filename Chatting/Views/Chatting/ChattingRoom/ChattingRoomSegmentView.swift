//
//  ChattingRoomSegmentView.swift
//  Chatting
//
//  Created by 박제형 on 3/14/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class ChattingRoomSegmentView: UIViewController {
    
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
    
    private let fileBox = ChattingRoomFileBoxView()
    private let gallery = ChattingRoomGalleryView()
    
    private let testView1: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isHidden = false
        return view
    }()
    
    private let testView2: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.isHidden = true
        return view
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
        
        rootFlexView.flex.define { flex in
            flex.addItem(segmentedControl).height(40)
            flex.addItem(underLine).width(view.frame.size.width / 2).height(2)
            flex.addItem(testView1)
            flex.addItem(testView2)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        testView1.pin.below(of: underLine).bottom()
        testView2.pin.below(of: underLine).bottom()
    }
    
    @objc func tapChanged() {
        
        let underlineWidth = view.frame.size.width / 2
        
        let underlineXPosition = CGFloat(segmentedControl.selectedSegmentIndex) * underlineWidth
        
        UIView.animate(withDuration: 0.3) {
            self.underLine.frame.origin.x = underlineXPosition
        }
        
        var shouldHideFirstView: Bool? {
            didSet {
                guard let shouldHideFirstView = shouldHideFirstView else { return }
                self.testView1.isHidden = shouldHideFirstView
                self.testView2.isHidden = !self.testView1.isHidden
            }
        }
        
        shouldHideFirstView = segmentedControl.selectedSegmentIndex != 0
    }
}
