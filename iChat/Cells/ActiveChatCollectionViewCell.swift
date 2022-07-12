//
//  ActiveChatCollectionViewCell.swift
//  iChat
//
//  Created by Наталья Шарапова on 10.07.2022.
//

import UIKit

class ActiveChatCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId = "ActiveChatCollectionViewCell"
    
    let friendImageView = UIImageView()
    let friendNameLabel = UILabel(text: "Name", textColor: .black, font: .laoSangamMN20()!)
    let lastMessageLabel = UILabel(text: "How are you?", textColor: .black, font: .laoSangamMN18()!)
    let gradientView = GradientView(from: .topLeading, to: .bottomTrailing, startColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), endColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstrains()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with value: MChat) {
        friendImageView.image = UIImage(named: value.userImageString)
        friendNameLabel.text = value.userName
        lastMessageLabel.text = value.lastMessage
    }
}

extension ActiveChatCollectionViewCell {
    
    private func setupConstrains() {
        addSubview(friendImageView)
        addSubview(gradientView)
        addSubview(friendNameLabel)
        addSubview(lastMessageLabel)
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .orange
        gradientView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78),
            
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 12),
            
            friendNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            friendNameLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: 16),
            friendNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 12),
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: 16),
            lastMessageLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 12),
        ])
    }
}

import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
    static var previews: some View {
        ActiveChatCellContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct ActiveChatCellContainerView: UIViewControllerRepresentable {
    
    let tabBarVc = MainTabBarController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return tabBarVc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
