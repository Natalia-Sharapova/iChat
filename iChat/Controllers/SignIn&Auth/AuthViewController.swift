//
//  AuthViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 06.07.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "chat"), contentMode: .scaleAspectFit)
    let emailButton = UIButton(title: "Email", backgroundColor: .black, titleColor: .white)
    let loginButton = UIButton(title: "Log in", backgroundColor: .white, titleColor: .purple, isShadow: true)
    let googleButton = UIButton(title: "Google", backgroundColor: .white, titleColor: .black, isShadow: true)
    
    let googleLabel = UILabel(text: "Get started with", textColor: .black)
    let emailLabel = UILabel(text: "Or sign up with", textColor: .black)
    let alreadyOnboardLabel = UILabel(text: "Already onboard?", textColor: .black)

    let signUpVC = SignUpViewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstrains()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        googleButton.customizeGoogleButton()
    }
    
    @objc func emailButtonTapped() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped() {
        present(loginVC, animated: true, completion: nil)
    }
}

extension AuthViewController {
    
    private func  setupConstrains() {
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let googleView = ButtonLabelView(label: googleLabel, button: googleButton)
        let emailView = ButtonLabelView(label: emailLabel, button: emailButton)
        let alreadyView = ButtonLabelView(label: alreadyOnboardLabel, button: loginButton)
        
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, alreadyView], axis: .vertical, spacing: 40)
        stackView.translatesAutoresizingMaskIntoConstraints = false
       
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}

import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct ContainerView: UIViewControllerRepresentable {
    let viewController = AuthViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
}
