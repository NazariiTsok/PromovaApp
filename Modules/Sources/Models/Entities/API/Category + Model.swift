//
//  File.swift
//
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation

extension CategoryModel: Identifiable {
    public var id: String {
        self.title
    }
}

public struct CategoryModel:Equatable, Sendable {
    
    public let title: String
    public let description: String
    public let image: String
    public let order: Int
    public let status: CategoryModel.Status
    public let facts: [FactModel]
    
    public init(
        title: String,
        description: String,
        image: String,
        order: Int,
        status: CategoryModel.Status,
        facts: [FactModel]
    ) {
        self.title = title
        self.description = description
        self.image = image
        self.order = order
        self.status = status
        self.facts = facts
    }
}

extension CategoryModel {
    public enum Status: String, Decodable, Sendable {
        case free
        case paid
        case comingSoon
    }
}


extension CategoryModel : Decodable {
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case image
        case order
        case status
        case content
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
            
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.image = try container.decode(String.self, forKey: .image)
        self.order = try container.decode(Int.self, forKey: .order)
        self.facts = try container.decodeIfPresent([FactModel].self, forKey: .content) ?? []
    
        self.status = facts.isEmpty ? .comingSoon : try container.decode(Status.self, forKey: .status)
    }
}


#if DEBUG
extension CategoryModel {
    public static var mock1 = CategoryModel(
        title: "Category 1",
        description: "Description 1",
        image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
        order: 1,
        status: .free,
        facts: FactModel.mock
    )

    public static var mock2 = CategoryModel(
        title: "Category 2",
        description: "Description 2",
        image: "https://static.wikia.nocookie.net/monster/images/6/6e/DragonRed.jpg/",
        order: 1,
        status: .paid,
        facts: FactModel.mock
    )

    public static var mock3 = CategoryModel(
        title: "Category 3",
        description: "Description 3",
        image: "https://images6.alphacoders.com/337/337780.jpg",
        order: 1,
        status: .comingSoon,
        facts: FactModel.mock
    )
}
#endif

