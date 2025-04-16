//
//  ChattingRoomFileBoxView.swift
//  Chatting
//
//  Created by 박제형 on 2/26/25.
//

import UIKit
import FlexLayout
import PinLayout
import QuickLook

class ChattingRoomFileBoxView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    var viewSelectMode: Bool = false
    var previewItem: QLPreviewItem?
    var fileURL: URL?
    
    var arr_fileBox: [FileBoxModel] = []
    var fileGrouped: [String : [FileBoxModel]] = [:]
    var selectedFiles: [FileBoxModel] = []
    
    private lazy var cv_fileBox: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChattingRoomCVHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChattingRoomCVHeaderView.identifier)
        collectionView.register(ChattingRoomFileBoxCell.self, forCellWithReuseIdentifier: ChattingRoomFileBoxCell.identifier)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parsing()
        initUI()
    }
    
    private func initUI() {
        view.backgroundColor = .white
        view.addSubview(rootFlexView)
        rootFlexView.backgroundColor = .white
        
        rootFlexView.flex.define { flex in
            flex.addItem(cv_fileBox)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        rootFlexView.flex.layout()
        
        cv_fileBox.pin.all().marginHorizontal(16)
    }
    
    func viewSelectMode(mode: Bool) {
        viewSelectMode = mode
        cv_fileBox.reloadData()
        mode ? nil : selectedFiles.removeAll()
    }
    
    func downloadFile() {
        print("download file: \(selectedFiles)")
    }
    
    func shareFile() {
        print("share file")
    }
    
    func deleteFile() {
        print("delete file")
    }
    
    private func  fileQuickLook(title: String, url: String) {
        guard let remoteURL = URL(string: url) else { return }
        
        let localPath = localPath(for: remoteURL)
        
        if FileManager.default.fileExists(atPath: localPath.path) {
            presentQuickLook(title: title, url: localPath)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: remoteURL) { downloadedUrl, response, error in
            guard let downloadedUrl = downloadedUrl, error == nil else { return }
            
            do {
                try FileManager.default.moveItem(at: downloadedUrl, to: localPath)
                
                DispatchQueue.main.async {
                    self.presentQuickLook(title: title, url: localPath)
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
    
    private func presentQuickLook(title: String, url: URL) {
        
        self.previewItem = CustomPreviewItem(previewItemURL: url, previewItemTitle: title)
        
        let preview = QLPreviewController()
        preview.delegate = self
        preview.dataSource = self
        self.present(preview, animated: true)
    }
    
    private func parsing() {
        
        let url = Bundle.main.url(forResource: "FileBox", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: url)
            let info = try JSONDecoder().decode([FileBoxModel].self, from: data)
            arr_fileBox = info
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        for file in arr_fileBox {
            let date = file.date.components(separatedBy: ".")[0]
            if var files = fileGrouped[date] {
                files.append(file)
                fileGrouped[date] = files
            } else {
                fileGrouped[date] = [file]
            }
        }
        
        arr_fileBox.removeAll()
        
        let dates = Array(fileGrouped.keys).sorted()
        for date in dates {
            if let images = fileGrouped[date] {
                arr_fileBox.append(contentsOf: images)
            }
        }
    }
    
}

extension ChattingRoomFileBoxView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dates = Array(fileGrouped.keys).sorted()
        let fileCount = fileGrouped[dates[section]]?.count ?? 0
        return fileCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingRoomFileBoxCell.identifier, for: indexPath) as! ChattingRoomFileBoxCell
        
        let dates = Array(fileGrouped.keys).sorted()
        let files = fileGrouped[dates[indexPath.section]] ?? []
        
        let type = files[indexPath.item].name.components(separatedBy: ".")[1]
        let name = files[indexPath.item].name
        let size = String(files[indexPath.item].size)
        
        cell.configure(type: type, name: name, size: size, selectMode: viewSelectMode)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChattingRoomCVHeaderView.identifier, for: indexPath) as! ChattingRoomCVHeaderView
        
        let dates = Array(fileGrouped.keys).sorted()
        header.configure(date: dates[indexPath.section])
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Array(fileGrouped.keys).count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dates = Array(fileGrouped.keys).sorted()
        var totalIndex = 0
        
        for i in 0..<indexPath.section {
            totalIndex += fileGrouped[dates[i]]?.count ?? 0
        }
        
        let selectedFileIndex = totalIndex + indexPath.item
        
        if !viewSelectMode {
            fileQuickLook(title: arr_fileBox[selectedFileIndex].name, url: arr_fileBox[selectedFileIndex].url)
        } else {
            selectedFiles.append(arr_fileBox[selectedFileIndex])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard viewSelectMode else { return }
        
        let dates = Array(fileGrouped.keys).sorted()
        var totalIndex = 0
        
        for i in 0..<indexPath.section {
            totalIndex += fileGrouped[dates[i]]?.count ?? 0
        }
        
        let deSelectedFileIndex = totalIndex + indexPath.item
        let deSelectedFile = arr_fileBox[deSelectedFileIndex]
        
        selectedFiles.removeAll { $0.url == deSelectedFile.url}
    }
    
}

extension ChattingRoomFileBoxView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 2 - 4
        return CGSize(width: size, height: size)
    }
}

extension ChattingRoomFileBoxView: QLPreviewControllerDelegate {
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        if let indexPath = cv_fileBox.indexPathsForSelectedItems?.first {
            cv_fileBox.deselectItem(at: indexPath, animated: false)
        }
    }
    
}

extension ChattingRoomFileBoxView: QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItem == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        return previewItem!
    }
    
}
