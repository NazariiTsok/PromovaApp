//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import ComposableArchitecture
import RealmRepository
import Models

public struct CategoryClientMock: CategoryClientProtocol {
    
    //TODO: Make unimplemented
    
    public func load() async throws {
        
    }
    
    public func getAll() async throws -> [CategoryModel] {
        return []
    }
    
    public func getBy(entityId: String) async throws -> CategoryModel? {
        return nil
    }
    
    public func insert(_ entity: CategoryModel) async throws {
        
    }
    
    public func upsert(_ entities: [CategoryModel]) async throws {
        
    }
    
    public func delete(_ entityId: String) async throws {
        
    }
    
    public func observation() -> AsyncThrowingStream<[CategoryModel], Error> {
        .finished()
    }
    
    public typealias Entity = CategoryModel
    
    
}
