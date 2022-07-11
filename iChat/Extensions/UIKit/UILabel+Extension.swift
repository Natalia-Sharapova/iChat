//
//  UILabel+Extension.swift
//  iChat
//
//  Created by Наталья Шарапова on 07.07.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, font: UIFont = .avenir20()!) {
        self.init()
        
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}
