//
//  ChattingRoomFileBoxView.swift
//  Chatting
//
//  Created by 박제형 on 2/26/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomFileBoxView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    var viewSelectMode: Bool = false
    
    var arr_fileBox: [FileBoxModel] = []
    var fileGrouped: [String : [FileBoxModel]] = [:]
    
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
