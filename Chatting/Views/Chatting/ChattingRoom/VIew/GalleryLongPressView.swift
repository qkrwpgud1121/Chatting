//
//  GalleryLongPressView.swift
//  Chatting
//
//  Created by 박제형 on 4/8/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

final class GalleryLongPressView: UIViewController {
    
    var viewWidth: CGFloat = 0
    var viewHeight: CGFloat = 0
    var selectImage = UIImage()
    
    private lazy var rootFlexView: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rootFlexView)
        
        rootFlexView.addSubview(blurEffectView)
        rootFlexView.addSubview(imageView)
        imageView.image = selectImage
        
    }
    
    @objc private func dismissPopup() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        blurEffectView.pin.all()
        rootFlexView.flex.layout()
        
        imageView.pin.vCenter().hCenter().width(viewWidth).height(viewHeight)
    }
}
