//
//  UserCollectionViewCell.swift
//  iChat
//
//  Created by Наталья Шарапова on 12.07.2022.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    let userImageView = UIImageView()
    let userNameLabel = UILabel(text: "text", textColor: .black, font: .laoSangamMN20()!)
    let containerView = UIView()
    
    static var reuseId = "UserCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstrains()
        
        self.layer.shadowColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 4)
        self.layer.cornerRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true
    }
   
    func configure<U>(with value: U) where U : Hashable {
        guard let user: MUser = value as? MUser else { return }
        
        userImageView.image = UIImage(named: user.userImageString)
        userNameLabel.text = user.userName
        
    }
    private func setupConstrains() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                                        userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
        
    }
    
    
    
}

import SwiftUI

struct UserCellProvider: PreviewProvider {
    static var previews: some View {
        UserContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct UserContainerView: UIViewControllerRepresentable {
    
    let tabBarVc = MainTabBarController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return tabBarVc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
