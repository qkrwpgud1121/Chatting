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
import AVFoundation

final class GalleryLongPressView: UIViewController {
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        blurView.addGestureRecognizer(tapGesture)
        return blurView
    }()
    
    private lazy var rootFlexView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPopup))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.define { flex in
            flex.addItem(testView).size(300)
        }
        
    }
    
    @objc private func dismissPopup() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        rootFlexView.flex.layout()
        
        testView.pin.vCenter().hCenter()
    }
}
