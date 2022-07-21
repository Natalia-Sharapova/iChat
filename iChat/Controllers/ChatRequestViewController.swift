//
//  ChatRequestViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 13.07.2022.
//

import UIKit

class ChatRequestViewController: UIViewController {
    
    let contaiterView = UIView()
    let imageView = UIImageView(image: #imageLiteral(resourceName: "human7"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Monica Bell", textColor: .black, font: .systemFont(ofSize: 20, weight: .light))
    let aboutLabel = UILabel(text: "Start new chat!", textColor: .black, font: .systemFont(ofSize: 16, weight: .light))
    let acceptButton = UIButton(title: "ACCEPT", cornerRadius: 10, backgroundColor: .black, titleColor: .white, font: .laoSangamMN20()!, isShadow: false)
    let denyButton = UIButton(title: "Deny", cornerRadius: 10, backgroundColor: #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1), titleColor: .red, font: .laoSangamMN20()!, isShadow: false)
    
    private var chat: MChat
    
    weak var delegate: WaitingChatNavigation?
   
    init(chat: MChat) {
        
        self.chat = chat
        nameLabel.text = chat.friendUserName
        imageView.kf.setImage(with: URL(string:(chat.friendAvatarStringURL)))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstrains()
        customizeElements()
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.acceptButton.applyGradient(cornerRadius: 10)
    }
    
   @objc private func denyButtonTapped() {
    
    self.dismiss(animated: true) {
        self.delegate?.removeWaitingChat(chat: self.chat)
    }
    }
    
    @objc func acceptButtonTapped() {
        self.dismiss(animated: true) {
            self.delegate?.changeToActive(chat: self.chat)
        
     }
     }
    
    private func customizeElements() {
        
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = UIColor.red.cgColor
        
        contaiterView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contaiterView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        contaiterView.layer.cornerRadius = 30
}
}

extension ChatRequestViewController {
    
    private func setupConstrains() {
        
        view.addSubview(imageView)
        view.addSubview(contaiterView)
        contaiterView.addSubview(nameLabel)
        contaiterView.addSubview(aboutLabel)
        
        let buttonsStackView = UIStackView(
            arrangedSubviews: [acceptButton, denyButton],
            axis: .horizontal,
            spacing: 8)
        
        contaiterView.addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.distribution = .fillEqually
        
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
            
            buttonsStackView.leadingAnchor.constraint(equalTo: contaiterView.leadingAnchor, constant: 24),
            buttonsStackView.trailingAnchor.constraint(equalTo: contaiterView.trailingAnchor, constant: -24),
            buttonsStackView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 24),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 52)
        ])
        
    }
}
