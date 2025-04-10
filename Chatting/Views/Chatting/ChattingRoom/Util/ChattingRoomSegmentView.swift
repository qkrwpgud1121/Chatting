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
    
    private let rootFlexView = UIView()
    
    var chatRoomName: String = ""
    var selectMode: Bool = false
    let safeAreaWidth = UIScreen.main.bounds.width
    lazy var bottomBarHeight: CGFloat = common.getBottomInsets() + 49
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var btn_selectMode: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["사진/동영상", "파일"])
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
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return segment
    }()
    
    private lazy var underLine: UIView = {
        let view = UIView()
        view.backgroundColor = common.commonBasicColor
        return view
    }()
    
    private lazy var pageViewControllers: [UIViewController] = {
        let fileBox = ChattingRoomFileBoxView()
        let gallery = ChattingRoomGalleryView()
        gallery.chatRoomName = chatRoomName
        return [gallery, fileBox]
    }()
    
    private lazy var pageView: UIPageViewController = {
        let pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageView.delegate = self
        pageView.dataSource = self
        return pageView
    }()
    
    let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var btn_download: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "arrow.down.to.line"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var btn_share: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "square.and.arrow.up"))
        button.tintColor = .black
        return button
    }()
    
    private lazy var btn_delete: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "trash"))
        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        addChild(pageView)
        pageView.didMove(toParent: self)
        pageView.setViewControllers([pageViewControllers.first!], direction: .forward, animated: true)
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn_selectMode)
        self.navigationItem.title = chatRoomName
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        componentAction()
    }
    
    private func componentAction() {
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        btn_selectMode.addAction(UIAction { _ in
            self.selectMode.toggle()
            if self.selectMode {
                self.pageView.delegate = nil
                self.pageView.dataSource = nil
            } else {
                self.pageView.delegate = self
                self.pageView.dataSource = self
            }
            if let galleryVC = self.pageViewControllers.first as? ChattingRoomGalleryView {
                galleryVC.viewSelectMode(mode: self.selectMode)
            }
            UIView.animate(withDuration: 0.3) {
                self.bottomBarSetHeight(height: self.selectMode ? self.bottomBarHeight : 0)
            }
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        rootFlexView.backgroundColor = .white
        
        rootFlexView.flex.define { flex in
            flex.addItem(segment).height(40)
            flex.addItem(underLine).width(view.frame.size.width / 2).height(2)
            flex.addItem(pageView.view)
        }
        
        rootFlexView.addSubview(bottomBar)
        
        bottomBar.flex.direction(.row).alignItems(.start).justifyContent(.spaceAround).paddingTop(16).define { bottomBar in
            bottomBar.addItem(btn_download)
            bottomBar.addItem(btn_share)
            bottomBar.addItem(btn_delete)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.left(view.pin.safeArea).right(view.pin.safeArea).top(view.pin.safeArea).bottom()
        rootFlexView.flex.layout()
        
        pageView.view.pin.below(of: underLine).bottom()
        bottomBarSetHeight(height: 0)
    }
    
    private func bottomBarSetHeight(height: CGFloat) {
        bottomBar.pin.bottom().width(safeAreaWidth).height(height)
        bottomBar.flex.layout()
    }
    
    @objc func segmentChanged() {
        segmentChaged(index: segment.selectedSegmentIndex)
    }
    
    private func segmentChaged(index: Int) {
        
        let underlineWidth = view.frame.size.width / 2
        let underlineXPosition = CGFloat(index) * underlineWidth
        
        UIView.animate(withDuration: 0.3) {
            self.underLine.frame.origin.x = underlineXPosition
            self.pageView.setViewControllers([self.pageViewControllers[index]], direction: index == 0 ? .reverse : .forward , animated: true)
        }
    }
}

extension ChattingRoomSegmentView: UIPageViewControllerDelegate {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentVC = pageViewController.viewControllers?.first else { return 0 }
        return pageViewControllers.firstIndex(of: currentVC) ?? 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllers.count
    }
    
}

extension ChattingRoomSegmentView: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return pageViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewControllers.firstIndex(of: viewController), index + 1 < self.pageViewControllers.count else { return nil }
        return pageViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers?.first {
                if let index = pageViewControllers.firstIndex(of: currentViewController) {
                    self.segment.selectedSegmentIndex = index
                    segmentChaged(index: index)
                }
            }
        }
    }
    
}
