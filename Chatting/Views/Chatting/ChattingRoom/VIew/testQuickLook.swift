//
//  testQuickLook.swift
//  Chatting
//
//  Created by 박제형 on 4/14/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout
import QuickLook

class testQuickLook: UIViewController {
    
    let rootFlexView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    var url: String = ""
    var fileURL: URL?
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.setTitle("test", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rootFlexView)
        
        rootFlexView.flex.define { flex in
            flex.addItem(testButton).width(100).height(60)
        }
        
        testButton.addAction(UIAction { _ in
            
            if let URL = URL(string: self.url) {
                self.fileURL = URL
            }
            
//            if let URL = Bundle.main.url(forResource: "은행여신거래기본약관(가계용)", withExtension: "pdf") {
//                self.fileURL = URL
//            }
            
            let preview = QLPreviewController()
            preview.dataSource = self
            self.present(preview, animated: true)
        }, for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        rootFlexView.flex.layout()
        
        testButton.pin.vCenter().hCenter()
    }
}

extension testQuickLook: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return fileURL == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        return fileURL! as QLPreviewItem
    }
    
}
