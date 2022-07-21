//
//  SetupProfileViewController.swift
//  iChat
//
//  Created by Наталья Шарапова on 08.07.2022.
//

import UIKit
import FirebaseAuth
import Kingfisher

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
    
    private let currentUser: User
    
    init(currentUser: User) {
      
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        if let userName = currentUser.displayName {
            fullNameTextField.text = userName
        }
        if let photoUrl = currentUser.photoURL {
            fullImageView.circleImageView.kf.setImage(with: photoUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstrains()
        
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
        fullImageView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    @objc func goToChatsButtonTapped() {
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: fullNameTextField.text,
                                                avatarImage: fullImageView.circleImageView.image,
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { result in
            switch result {
            
            case .success(let muser):
                self.showAlert(with: "Succeded!", and: "Have a nice conversation!") {
                    let mainTabBarVC = MainTabBarController(currentUser: muser)
                    mainTabBarVC.modalPresentationStyle = .fullScreen
                    self.present(mainTabBarVC, animated: true, completion: nil)
                    print(#function, "success")
                }
                print(#function, muser)
            case .failure(let error):
                self.showAlert(with: "Opps", and: error.localizedDescription)
                print(#function, String(describing: error))
            }
    }
        }
    
    @objc func plusButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension SetupProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        fullImageView.circleImageView.image = image
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
        
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
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
    
    let viewController = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
