

import Foundation
import RealmSwift

public final class FactEntity: Object {
    
    @Persisted public var fact: String
    @Persisted public var image: String
}

// MARK: - Model Extensions for Data Conversion

extension FactEntity {
   public static func from(domainModel: FactModel) -> FactEntity {
        let model = FactEntity()
        model.fact = domainModel.fact
        model.image = domainModel.image
        return model
    }
    
   public var toDomainModel: FactModel {
       FactModel(fact: fact, image: image)
    }
}
