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
            self.fileDownload()
        }, for: .touchUpInside)
    }
    
    private func  fileDownload() {
        guard let remoteURL = URL(string: url) else { return }
        
        let localPath = localPath(for: remoteURL)
        
        if FileManager.default.fileExists(atPath: localPath.path) {
            presentQuickLook(url: localPath)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: remoteURL) { downloadedUrl, response, error in
            guard let downloadedUrl = downloadedUrl, error == nil else { return }
            
            do {
                try FileManager.default.moveItem(at: downloadedUrl, to: localPath)
                
                DispatchQueue.main.async {
                    self.presentQuickLook(url: localPath)
                }
            } catch {
                print("실패: \(error)")
            }
        }
        task.resume()
    }
    
    private func localPath(for remoteURL: URL) -> URL {
        let fileName = remoteURL.lastPathComponent
        let tempDir = FileManager.default.temporaryDirectory
        return tempDir.appendingPathComponent(fileName)
    }
    
    private func presentQuickLook(url: URL) {
        self.fileURL = url
        let preview = QLPreviewController()
        preview.dataSource = self
        self.present(preview, animated: true)
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
