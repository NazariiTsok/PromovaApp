//
//  File.swift
//
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation

public struct FactModel:  Equatable, Sendable  {
    public let fact: String
    public let image: String
    
    public init(
        fact: String,
        image: String
    ) {
        self.fact = fact
        self.image = image
    }
}

extension FactModel : Decodable {
    enum CodingKeys: String, CodingKey {
        case fact
        case image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        self.fact = try container.decode(String.self, forKey: .fact)
        self.image = try container.decode(String.self, forKey: .image)
    }
}

#if DEBUG
extension FactModel {
    public static let mock: [FactModel] = [
        .init(fact: "Interesting Fact 1", image: "https://cdn2.thecatapi.com/images/5op.jpg"),
        .init(fact: "Interesting Fact 2", image: "https://cdn2.thecatapi.com/images/b8j.jpg"),
        .init(fact: "Interesting Fact 3", image: "https://cdn2.thecatapi.com/images/bgr.jpg"),
    ]
}
#endif
