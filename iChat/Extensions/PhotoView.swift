//
//  PhotoView.swift
//  iChat
//
//  Created by Наталья Шарапова on 08.07.2022.
//

import UIKit

class PhotoView: UIView {
    
    var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 45
        imageView.backgroundColor = .yellow
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(circleImageView)
        addSubview(plusButton)
        
        setupConstrains()
    }
    
    private func setupConstrains() {
        circleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        circleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        circleImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        circleImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
