//
//  ChattingRoomGalleryDetailView.swift
//  Chatting
//
//  Created by 박제형 on 3/24/25.
//

import Foundation
import FlexLayout
import PinLayout

class ChattingRoomGalleryDetailView: UIViewController {
    
    let common = Common()
    var arr_GalleryImage: [GalleryImageModel] = []
    
    var chatRoomName: String = ""
    var selectedImageIndex: Int = 0
    
    let rootFlexView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let safeAreaWidth = UIScreen.main.bounds.width
    let safeAreaHeight = UIScreen.main.bounds.height
    
    let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .white
        return button
    }()
    
    let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var btn_download: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "arrow.down.to.line"))
        button.tintColor = .white
        return button
    }()
    
    private lazy var btn_share: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "square.and.arrow.up"))
        button.tintColor = .white
        return button
    }()
    
    private lazy var btn_delete: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "trash"))
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        componentAction()
    }
    
    private func componentAction() {
        
        dismissButton.addAction(UIAction { _ in
            self.dismiss(animated: true)
        }, for: .touchUpInside)
        
        initUI()
    }
    
    private func initUI() {
        
        rootFlexView.backgroundColor = .black
        
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.define { flex in
            
            flex.addItem(topBar).direction(.row).define { topBar in
                topBar.addItem(dismissButton)
            }
            
            flex.addItem(bottomBar).direction(.row).justifyContent(.spaceAround).paddingTop(12).define { bottomBar in
                bottomBar.addItem(btn_download)
                bottomBar.addItem(btn_share)
                bottomBar.addItem(btn_delete)
            }
        }
        
        
//        rootFlexView.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//        
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.isPagingEnabled = true
//
//        contentView.flex.direction(.row).define { flex in
//            
//            for image in arr_GalleryImage {
//                let profileImageView: UIImageView = {
//                    let imageView = UIImageView()
//                    imageView.image = UIImage(named: "\(image.url)")
//                    imageView.contentMode = .scaleAspectFit
//                    return imageView
//                }()
//                
//                flex.addItem(profileImageView).width(safeAreaWidth)
//            }
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        
        rootFlexView.pin.all()
        rootFlexView.flex.layout()
        
        topBar.pin.top().width(view.frame.size.width).height(common.getTopInsets() + navBarHeight)
        bottomBar.pin.bottom().width(view.frame.size.width).height(common.getBottomInsets() + 54)
//        scrollView.pin.all(view.pin.safeArea)
//        contentView.pin.all()
//        
//        contentView.flex.layout(mode: .adjustWidth)
//        
//        scrollView.contentSize = contentView.frame.size
//        
//        if selectedImageIndex < arr_GalleryImage.count {
//            scrollView.setContentOffset(CGPoint(x: safeAreaWidth * CGFloat(selectedImageIndex), y: 0), animated: false)
//        }
    }
    
}

