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
    var viewMode: Bool = false
    lazy var topBarHeight: CGFloat = common.getTopInsets() + 40
    lazy var bottomBarHeight: CGFloat = common.getBottomInsets() + 49
    
    let rootFlexView = UIView()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        scrollView.addGestureRecognizer(tapGesture)
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
        
        rootFlexView.addSubview(topBar)
        
        topBar.flex.direction(.row).alignItems(.end).paddingBottom(8).paddingHorizontal(16).define { topBar in
            topBar.addItem(dismissButton).size(30).marginRight(8).paddingBottom(16)
            topBar.addItem().grow(1).define { senderDataView in
                senderDataView.addItem(senderName)
                senderDataView.addItem(sendDate)
            }
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
        
        rootFlexView.pin.all()
        scrollView.pin.all()
        contentView.pin.all()
        contentView.flex.layout(mode: .adjustWidth)
        
        scrollView.contentSize = contentView.frame.size
        
        if selectedImageIndex < arr_GalleryImage.count {
            scrollView.setContentOffset(CGPoint(x: safeAreaWidth * CGFloat(selectedImageIndex), y: 0), animated: false)
        }
        
        topBarSetHeight(height: topBarHeight)
        bottomBarSetHeight(height: bottomBarHeight)
        
        senderName.text = arr_GalleryImage[selectedImageIndex].senderName
        sendDate.text = arr_GalleryImage[selectedImageIndex].date
        
    }
    
    private func topBarSetHeight(height: CGFloat) {
        topBar.pin.top().width(safeAreaWidth).height(height)
        topBar.flex.layout()
    }
    
    private func bottomBarSetHeight(height: CGFloat) {
        bottomBar.pin.bottom().width(safeAreaWidth).height(height)
        bottomBar.flex.layout()
    }
    
    @objc func viewTapped() {
        
        viewMode.toggle()
        
        UIView.animate(withDuration: 0.3) {
            
            self.topBarSetHeight(height: self.viewMode ? 0 : self.topBarHeight)
            self.bottomBarSetHeight(height: self.viewMode ? 0 : self.bottomBarHeight)
        }
    }
    
}

extension ChattingRoomGalleryDetailView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        senderName.text = arr_GalleryImage[page].senderName
        sendDate.text = arr_GalleryImage[page].date
    }
}
