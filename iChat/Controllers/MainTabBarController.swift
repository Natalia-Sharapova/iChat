//
//  MainTabBarController.swift
//  iChat
//
//  Created by Наталья Шарапова on 09.07.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    private let currentUser: MUser
    
    init(currentUser: MUser = MUser(userName: "Nat",
                                    email: "test100@mail.ru",
                                    avatarStringURL: "nil",
                                    description: "Hi",
                                    sex: "Female",
                                    id: "qqq")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let peopleVC = PeopleViewController(currentUser: currentUser)
        let listVC = ListViewController(currentUser: currentUser)
        
        tabBar.tintColor = .purple
        
        let peopleImage = UIImage(systemName: "person.2")!
        let chatImage = UIImage(systemName: "bubble.left.and.bubble.right")!
        
        viewControllers = [
            generateNavigationVC(rootVC: peopleVC, title: "People", image: peopleImage),
            generateNavigationVC(rootVC: listVC, title: "Chats", image: chatImage),
        ]
    }
    
    // MARK: - Methods
    
    private func generateNavigationVC(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
