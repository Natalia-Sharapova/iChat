//
//  LoginViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 08.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Labels
    let welcomeLabel = UILabel(text: "Welcome back!", textColor: .black, font: .avenir26()!)
    let loginWithLabel = UILabel(text: "Log in with", textColor: .black)
    let orLabel = UILabel(text: "or", textColor: .black)
    let emailLabel = UILabel(text: "Email", textColor: .black)
    let passwordLabel = UILabel(text: "Password", textColor: .black)
    let needAnAccountLabel = UILabel(text: "Need a account?", textColor: .black)
    
    // MARK: - Buttons
    let googleButton = UIButton(title: "Google", cornerRadius: 5, backgroundColor: .white, titleColor: .black, font: .avenir20()!, isShadow: true)
    let loginButton = UIButton(title: "Log in", cornerRadius: 5, backgroundColor: .black, titleColor: .white, font: .avenir20()!)
    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.titleLabel?.font = UIFont.avenir20()
        return button
    }()
    
    // MARK: - Text fields
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    

    override func viewDidLoad() {
        super.viewDidLoad()
     setupConstrains()
        googleButton.customizeGoogleButton()
    }

}

extension LoginViewController {
    
    private func setupConstrains() {
        
        let loginWithView = ButtonLabelView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews:
                                            [emailLabel, emailTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews:
                                            [passwordLabel, passwordTextField],
                                         axis: .vertical,
                                         spacing: 0)
        
        let stackView = UIStackView(arrangedSubviews: [
            loginWithView,
            orLabel,
            emailStackView,
            passwordStackView,
            loginButton
        ],
        axis: .vertical,
        spacing: 40)
        
        let bottomStackView = UIStackView(arrangedSubviews: [
            needAnAccountLabel,
            signInButton
        ],
        axis: .horizontal,
        spacing: 0)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 130).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}
        

import SwiftUI

struct LoginViewControllerProvider: PreviewProvider {
    static var previews: some View {
        LoginContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct LoginContainerView: UIViewControllerRepresentable {
    let viewController = LoginViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}