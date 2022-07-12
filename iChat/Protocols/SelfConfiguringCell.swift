//
//  SelfConfiguringCell.swift
//  iChat
//
//  Created by Наталья Шарапова on 11.07.2022.
//

import Foundation


protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}

