//
//  WaitingChatCollectionViewCell.swift
//  iChat
//
//  Created by Наталья Шарапова on 11.07.2022.
//

import UIKit

class WaitingChatCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "WaitingChatCollectionViewCell"
    let friendImageView = UIImageView()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configure<U>(with value: U) where U : Hashable {
        guard let waitingChat: MChat = value as? MChat else { return }
        friendImageView.image = UIImage(named: waitingChat.userImageString)
    }
    
  
    
    private func setupConstrains() {
    addSubview(friendImageView)
    
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendImageView.topAnchor.constraint(equalTo: self.topAnchor),
            friendImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
}
}

import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
    static var previews: some View {
        WaitingChatCellContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct WaitingChatCellContainerView: UIViewControllerRepresentable {
    
    let tabBarVc = MainTabBarController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return tabBarVc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
