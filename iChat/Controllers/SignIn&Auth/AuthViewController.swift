//
//  AuthViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 06.07.2022.
//

import UIKit
import GoogleSignIn
import Firebase

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
        
        signUpVC.delegate = self
        loginVC.delegate = self
        
        setupConstrains()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        googleButton.customizeGoogleButton()
    }
    
    @objc func emailButtonTapped() {
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped() {
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped() {
        
        AuthService.shared.googleLogin(viewController: self) { result in
            
            switch result {
            case .success(let user):
                FirestoreService.shared.getUserData(user: user) { result in
                    switch result {
                    case .success(let muser):
                        
                        UIApplication.getTopViewController()?.showAlert(with: "Successfully!", and: "You are logged in!") {
                            let mainTabBar = MainTabBarController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            UIApplication.getTopViewController()!.present(mainTabBar, animated: true, completion: nil)
                        }
                    case .failure(_):
                        UIApplication.getTopViewController()?.showAlert(with: "Successfully!", and: "You are registered!") {
                            UIApplication.getTopViewController()?.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                UIApplication.getTopViewController()?.showAlert(with: "Oops, something went wrong", and: error.localizedDescription)
            }
        }
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
        stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 70).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
}

extension AuthViewController: AuthNavDelegate {
    
    func toLoginVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
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
