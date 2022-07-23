//
//  UIView+Extension.swift
//  iChat
//
//  Created by Наталья Шарапова on 13.07.2022.
//

import UIKit

extension UIView {
    
    func applyGradient(cornerRadius: CGFloat) {
        
        self.backgroundColor = nil
        self.layoutIfNeeded()
        
        let gradientView = GradientView(from: .topLeading, to: .bottomTrailing, startColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), endColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
