//
//  ProfileViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 13.07.2022.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    let contaiterView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human5"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Monica Bell", textColor: .black, font: .systemFont(ofSize: 20, weight: .light))
    let aboutLabel = UILabel(text: "Write to me", textColor: .black, font: .systemFont(ofSize: 16, weight: .light))
    
    let textField = CustomTextField()
    private var user: MUser
    
    init(user: MUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        self.nameLabel.text = user.userName
        self.aboutLabel.text = user.description
        
        guard let url = URL(string: user.avatarStringURL) else { return }
        self.imageView.kf.setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeElements()
        setupConstrains()
    }
    
    // MARK: - Methods
    private func customizeElements() {
        
        contaiterView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        contaiterView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        aboutLabel.numberOfLines = 0
        contaiterView.backgroundColor = UIColor.milkWhite()
        contaiterView.layer.cornerRadius = 30
        
        guard let button = textField.rightView as? UIButton else { return }
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    @objc func sendMessage() {
        
        guard let message = textField.text, message != "" else { return }
        
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChat(message: message, receiver: self.user) { result in
                
                switch result {
                case .success():
                    UIApplication.getTopViewController()?.showAlert(with: "Success!", and: "Your message to \(self.user.userName) was sent")
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Extensions
extension ProfileViewController {
    
    private func setupConstrains() {
        
        view.addSubview(imageView)
        view.addSubview(contaiterView)
        contaiterView.addSubview(nameLabel)
        contaiterView.addSubview(aboutLabel)
        contaiterView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            contaiterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contaiterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contaiterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contaiterView.heightAnchor.constraint(equalToConstant: 206),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contaiterView.topAnchor, constant: 30),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contaiterView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: contaiterView.trailingAnchor, constant: -24),
            nameLabel.topAnchor.constraint(equalTo: contaiterView.topAnchor, constant: 35),
            
            aboutLabel.leadingAnchor.constraint(equalTo: contaiterView.leadingAnchor, constant: 24),
            aboutLabel.trailingAnchor.constraint(equalTo: contaiterView.trailingAnchor, constant: -24),
            aboutLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            textField.leadingAnchor.constraint(equalTo: contaiterView.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: contaiterView.trailingAnchor, constant: -24),
            textField.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 12),
            textField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
