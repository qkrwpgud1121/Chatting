//
//  ChattingRoomFileBoxView.swift
//  Chatting
//
//  Created by 박제형 on 2/26/25.
//

import UIKit
import FlexLayout
import PinLayout

class ChattingRoomGalleryView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    
    var chatRoomName: String = ""
    var arr_GalleryImage: [GalleryImageModel] = []
    var groupedImages: [String: [GalleryImageModel]] = [:]
    
    private lazy var cv_fileBox: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChattingRoomCVHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChattingRoomCVHeaderView.identifier)
        collectionView.register(ChattingRoomGalleryCell.self, forCellWithReuseIdentifier: ChattingRoomGalleryCell.identifier)
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
        
        rootFlexView.pin.all(view.pin.safeArea)
        rootFlexView.flex.layout()
        
        cv_fileBox.pin.all()
    }
    
    private func parsing() {
        
        let url = Bundle.main.url(forResource: "GalleryImage", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: url)
            let info = try JSONDecoder().decode([GalleryImageModel].self, from: data)
            arr_GalleryImage = info
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        for image in arr_GalleryImage {
            let date = image.date.components(separatedBy: ".")[0]
            if var images = groupedImages[date] {
                images.append(image)
                groupedImages[date] = images
            } else {
                groupedImages[date] = [image]
            }
        }
        
        arr_GalleryImage.removeAll()
        
        let dates = Array(groupedImages.keys).sorted()
        for date in dates {
            if let images = groupedImages[date] {
                arr_GalleryImage.append(contentsOf: images)
            }
        }
    }
    
}

extension ChattingRoomGalleryView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // section 별 image 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dates = Array(groupedImages.keys).sorted()
        let images = groupedImages[dates[section]]?.count ?? 0
        return images
    }
    
    // section 별 image 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChattingRoomGalleryCell.identifier, for: indexPath) as! ChattingRoomGalleryCell
        
        let dates = Array(groupedImages.keys).sorted()
        let images = groupedImages[dates[indexPath.section]] ?? []
        
        cell.configure(imageURL: images[indexPath.item].url)
        
        return cell
    }
    
    // header view text 설정
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChattingRoomCVHeaderView.identifier, for: indexPath) as! ChattingRoomCVHeaderView
        
        let dates = Array(groupedImages.keys).sorted()
        header.configure(date: dates[indexPath.section])
        
        return header
    }
    
    // header view 의 size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }
    
    // section 의 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Array(groupedImages.keys).count
    }
    
    // image select action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dates = Array(groupedImages.keys).sorted()
        var totalIndex = 0
        
        for i in 0..<indexPath.section {
            totalIndex += groupedImages[dates[i]]?.count ?? 0
        }
        
        let selectedImageIndex = totalIndex + indexPath.item
        
        let galleryDetailVC = ChattingRoomGalleryDetailView()
        galleryDetailVC.chatRoomName = chatRoomName
        galleryDetailVC.arr_GalleryImage = arr_GalleryImage
        galleryDetailVC.selectedImageIndex = selectedImageIndex
        galleryDetailVC.modalPresentationStyle = .fullScreen
        self.present(galleryDetailVC, animated: true)
    }
    
}

extension ChattingRoomGalleryView: UICollectionViewDelegateFlowLayout {
    
    // image view 간 세로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    // image view 간 가로 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    // 이미지 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3 - 4   /// collectionView 3칸 사이간격 4
        return CGSize(width: size, height: size)        /// imageView 정사각형
    }
}
