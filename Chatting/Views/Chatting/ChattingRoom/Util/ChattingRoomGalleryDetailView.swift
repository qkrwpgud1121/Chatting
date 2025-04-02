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
    
    let safeAreaWidth = UIScreen.main.bounds.width
    let safeAreaHeight = UIScreen.main.bounds.height
    
    var chatRoomName: String = ""
    var selectedImageIndex: Int = 0
    
    let rootFlexView = UIView()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    let contentView = UIView()
    
    let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .white
        return button
    }()
    
    let senderDataView = UIView()
    
    private lazy var senderName: UILabel = {
        let label = UILabel()
        label.text = "senderName"
        label.textColor = .white
        return label
    }()
    
    private lazy var sendDate: UILabel = {
        let label = UILabel()
        label.text = "sendDate"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
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
        rootFlexView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.flex.direction(.row).define { contentView in
            for image in arr_GalleryImage {
                let profileImageView: UIImageView = {
                    let imageView = UIImageView()
                    imageView.image = UIImage(named: "\(image.url)")
                    imageView.contentMode = .scaleAspectFit
                    return imageView
                }()
                
                contentView.addItem(profileImageView).width(safeAreaWidth)
            }
        }
        
        rootFlexView.addSubview(bottomBar)
        
        bottomBar.flex.direction(.row).alignItems(.start).justifyContent(.spaceAround).paddingTop(16).define { bottomBar in
            bottomBar.addItem(btn_download)
            bottomBar.addItem(btn_share)
            bottomBar.addItem(btn_delete)
        }
        
        rootFlexView.addSubview(topBar)
        
        topBar.flex.direction(.row).alignItems(.end).paddingBottom(8).paddingHorizontal(16).define { topBar in
            topBar.addItem(dismissButton)
            topBar.addItem(senderDataView).alignItems(.center).define { senderDataView in
                senderDataView.addItem(senderName)
                senderDataView.addItem(sendDate)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustWidth)
        
        scrollView.contentSize = contentView.frame.size
        
        if selectedImageIndex < arr_GalleryImage.count {
            scrollView.setContentOffset(CGPoint(x: safeAreaWidth * CGFloat(selectedImageIndex), y: 0), animated: false)
        }
        
        bottomBar.pin.bottom().width(safeAreaWidth).height(common.getBottomInsets() + 49)
        bottomBar.flex.layout()
        
        topBar.pin.top().width(safeAreaWidth).height(common.getTopInsets() + 40)
        topBar.flex.layout()
        
        senderDataView.pin.bottomCenter(to: topBar.anchor.bottomCenter).margin(4)
        senderDataView.flex.layout()
    }
    
}

