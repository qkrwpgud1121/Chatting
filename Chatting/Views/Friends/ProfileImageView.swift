//
//  ProfileImageView.swift
//  Chatting
//
//  Created by 박제형 on 2/4/25.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

class ProfileImageView: UIViewController {
    
    let common = Common()
    
    let rootFlexView = UIView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    var profileImageName: String!
    
    var profileImages: [ImageDetailModel] = []
    
    let safeAreaWidth = UIScreen.main.bounds.width
    let safeAreaHeight = UIScreen.main.bounds.height
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton(configuration: common.buttonConfig(pointSize: 15, image: "xmark"))
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //parsing()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        self.navigationItem.title = "1 / \(profileImages.count)"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        setupButtonAction()
    }
    
    func setupButtonAction() {
        
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
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        
        contentView.flex.direction(.row).define { flex in
            
            for image in profileImages {
                let profileImageView: UIImageView = {
                    let imageView = UIImageView()
                    imageView.image = UIImage(named: "\(image.imageUrl)")
                    imageView.contentMode = .scaleAspectFit
                    return imageView
                }()
                
                flex.addItem(profileImageView).width(safeAreaWidth)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        rootFlexView.pin.all()
        scrollView.pin.all(view.pin.safeArea)
        contentView.pin.all()
        
        contentView.flex.layout(mode: .adjustWidth)
        
        scrollView.contentSize = contentView.frame.size
        
    }
    
    private func parsing() {
        
        let url = Bundle.main.url(forResource: "ProfileImages", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: url)
            let info = try JSONDecoder().decode([ImageDetailModel].self, from: data)
            profileImages = info
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
}

extension ProfileImageView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int(scrollView.contentOffset.x / pageWidth) + 1
        self.navigationItem.title = "\(currentPage) / \(profileImages.count)"
    }
}
