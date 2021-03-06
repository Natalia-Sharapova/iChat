//
//  SignUpViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 07.07.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    // Labels
    let welcomeLabel = UILabel(text: "Hello!", textColor: .black, font: .avenir26()!)
    let emailLabel = UILabel(text: "Email", textColor: .black)
    let passwordLabel = UILabel(text: "Password", textColor: .black)
    let confirmPasswordLabel = UILabel(text: "Confirm password", textColor: .black)
    let alreadyOnboardLabel = UILabel(text: "Already onboard?", textColor: .black)
    
    // Buttons
    let signUpButton = UIButton(title: "Sign up", backgroundColor: .black, titleColor: .white)
    let logInButton = UIButton()
    
    // Text fields
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    
    weak var delegate: AuthNavDelegate?
    
    // MARK: - ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.milkWhite()
        
        logInButton.setTitle("Log in", for: .normal)
        logInButton.setTitleColor(.purple, for: .normal)
        
        setupConstrains()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        logInButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Methods
    
    @objc func signUpButtonTapped() {
        AuthService.shared.register(email: emailTextField.text,
                                    password: passwordTextField.text,
                                    confirmPassword: confirmPasswordTextField.text) { result in
            switch result {
            
            case .success(let user):
                self.showAlert(with: "Success", and: "You're successfully registered") {
                    self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(with: "Oops", and: "Something went wrong: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func loginButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
}

// MARK: - Extensions

extension SignUpViewController {
    
    private func setupConstrains() {
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
        
        signUpButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logInButton.contentHorizontalAlignment = .leading
        
        let stackView = UIStackView(arrangedSubviews: [
                                        emailStackView, passwordStackView, confirmPasswordStackView, signUpButton],
                                    axis: .vertical,
                                    spacing: 40)
        
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, logInButton],
                                          axis: .horizontal,
                                          spacing: 20)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 130).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 50).isActive = true
        bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        bottomStackView.alignment = .firstBaseline
        
    }
}

// MARK: - For Canvas mode

import SwiftUI

struct SignUpViewControllerProvider: PreviewProvider {
    static var previews: some View {
        SignUpContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct SignUpContainerView: UIViewControllerRepresentable {
    let viewController = SignUpViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
