//
//  SetupProfileViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 08.07.2022.
//

import UIKit

class SetupProfileViewController: UIViewController {

    let fullImageView = PhotoView()
    
    // MARK: - Labels
    let welcomeLabel = UILabel(text: "Set up profile", textColor: .black, font: .avenir26()!)
    let fullNameLabel = UILabel(text: "Full name", textColor: .black)
    let aboutMeLabel = UILabel(text: "About me", textColor: .black)
    let sexLabel = UILabel(text: "Sex", textColor: .black)
    
    // MARK: - Text fields
    let fullNameTextField = OneLineTextField(font: .avenir20())
    let aboutMeTextField = OneLineTextField(font: .avenir20())
    
    // MARK: - UISegmentedControl
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    // MARK: - Button
    let goToChatsButton = UIButton(title: "Go to chats!", cornerRadius: 5, backgroundColor: .black, titleColor: .white, font: .avenir20()!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstrains()
    }
}

// MARK: - Setup constrains

extension SetupProfileViewController {
    
    private func setupConstrains() {
        
        // MARK: - Full imageView
        
        view.addSubview(fullImageView)
        
        // MARK: - StackViews
        
        let fullNameStackView = UIStackView(arrangedSubviews: [
        fullNameLabel,
        fullNameTextField
        ],
        axis: .vertical,
        spacing: 0)
        
        let aboutMeStackView = UIStackView(arrangedSubviews: [
        aboutMeLabel,
        aboutMeTextField
        ],
        axis: .vertical,
        spacing: 0)
        
        let sexStackView = UIStackView(arrangedSubviews: [
        sexLabel,
        sexSegmentedControl
        ],
        axis: .vertical,
        spacing: 10)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [
        fullNameStackView,
            aboutMeStackView,
            sexStackView,
            goToChatsButton
        ],
        axis: .vertical,
        spacing: 40)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        fullImageView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40).isActive = true
        fullImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: fullImageView.bottomAnchor, constant: 100).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
    }
}

import SwiftUI

struct SetupProfileViewControllerProvider: PreviewProvider {
    static var previews: some View {
        SetupProfileContainerView().edgesIgnoringSafeArea(.all)
    }
}

struct SetupProfileContainerView: UIViewControllerRepresentable {
    let viewController = SetupProfileViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
