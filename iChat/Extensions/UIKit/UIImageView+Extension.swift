//
//  UIImageView+Extension.swift
//  iChat
//
//  Created by Наталья Шарапова on 07.07.2022.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
}
