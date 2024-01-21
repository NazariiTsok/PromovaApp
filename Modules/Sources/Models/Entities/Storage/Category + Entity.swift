//
//  File.swift
//
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import RealmSwift

public final class CategoryEntity: Object, Identifiable {
    
   
    @Persisted(primaryKey: true) public dynamic var id: String
    
    @Persisted public var title: String
    @Persisted public var categoryDescription: String // 'description' is a reserved word in Realm
    @Persisted public var image: String
    @Persisted public var order: Int
    @Persisted public var status: Status
    @Persisted public var facts: RealmSwift.List<FactEntity>
    
    public enum Status: String, PersistableEnum {
        case free
        case paid
        case comingSoon
    }
    
    public override class func primaryKey() -> String? {
           return "id"
       }
    
//    public init(
//        id: String,
//        title: String,
//        categoryDescription: String,
//        image: String,
//        order: Int,
//        status: Status,
//        facts: RealmSwift.List<FactEntity>
//    ) {
//        super.init()
//        
//        self.id = id
//        self.title = title
//        self.categoryDescription = categoryDescription
//        self.image = image
//        self.order = order
//        self.status = status
//        self.facts = facts
//    }
}

// MARK: - Model Extensions for Data Conversion

extension CategoryEntity {
    public static func from(domainModel: CategoryModel) -> CategoryEntity {
        let model = CategoryEntity()
        model.id = domainModel.id
        model.title = domainModel.title
        model.categoryDescription = domainModel.description
        model.image = domainModel.image
        model.order = domainModel.order
        model.status = CategoryEntity.Status(rawValue: domainModel.status.rawValue) ?? .free
        model.facts.append(objectsIn: domainModel.facts.map(FactEntity.from)) // Updated reference
        return model
    }
    
    public var toDomainModel: CategoryModel {
        CategoryModel(
            title: title,
            description: categoryDescription,
            image: image,
            order: order,
            status: CategoryModel.Status(rawValue: status.rawValue) ?? .free,
            facts: facts.map(\.toDomainModel)
        )
    }
}
