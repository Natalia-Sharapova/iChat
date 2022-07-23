//
//  Bundle+Decodable.swift
//  iChat
//
//  Created by Наталья Шарапова on 10.07.2022.
//

import UIKit

extension Bundle {
    
    func decode<T: Decodable>(_type: T.Type, from file: String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locale \(file) in bundle")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle")
        }
        let decoder = JSONDecoder()
        
        guard let decoded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode")
        }
        return decoded
    }
}
