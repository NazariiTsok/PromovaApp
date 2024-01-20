//
//  File.swift
//
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation

public struct FactModel: Identifiable, Equatable, Sendable  {
    public let id: String
    public let fact: String
    public let image: String
    
    public init(
        id: String,
        fact: String,
        image: String
    ) {
        self.id = id
        self.fact = fact
        self.image = image
    }
}

extension FactModel {
    static let mock: [FactModel] = [
        .init(id: "f1", fact: "Interesting Fact 1", image: "https://cdn2.thecatapi.com/images/5op.jpg"),
        .init(id: "f2", fact: "Interesting Fact 2", image: "https://cdn2.thecatapi.com/images/b8j.jpg"),
        .init(id: "f3", fact: "Interesting Fact 3", image: "https://cdn2.thecatapi.com/images/bgr.jpg"),
    ]
}


extension FactModel : Decodable {
    enum CodingKeys: String, CodingKey {
        case fact
        case image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID().uuidString
        
        self.fact = try container.decode(String.self, forKey: .fact)
        self.image = try container.decode(String.self, forKey: .image)
    }
}

