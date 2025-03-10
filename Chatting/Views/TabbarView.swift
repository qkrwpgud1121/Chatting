//
//  TabbarView.swift
//  Chatting
//
//  Created by 박제형 on 1/7/25.
//

import UIKit

class TabbarView: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        
        let friendVC = UINavigationController(rootViewController: FriendListView())
        friendVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        let chattingVC = UINavigationController(rootViewController: ChattingListView())
        chattingVC.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        
        viewControllers = [friendVC, chattingVC]
    }
}
