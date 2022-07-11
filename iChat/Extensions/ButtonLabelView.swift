//
//  ButtonLabelView.swift
//  iChat
//
//  Created by Наталья Шарапова on 07.07.2022.
//

import UIKit

class ButtonLabelView: UIView {
    
    init(label: UILabel, button: UIButton) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(button)
        
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
