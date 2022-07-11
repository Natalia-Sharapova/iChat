//
//  UIButton+Extension.swift
//  iChat
//
//  Created by Наталья Шарапова on 06.07.2022.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(title: String,
                     cornerRadius: CGFloat = 5,
                     backgroundColor: UIColor,
                     titleColor: UIColor,
                     font: UIFont = .avenir20()!,
                     isShadow: Bool = false) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        
    }
    
    func customizeGoogleButton() {
        let imageLogo = UIImageView(image: #imageLiteral(resourceName: "google"), contentMode: .scaleAspectFit)
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageLogo)
        imageLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24).isActive = true
        imageLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
