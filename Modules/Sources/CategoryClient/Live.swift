//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import Models
import RealmRepository
import APIClient

public struct CategoryClient : CategoryClientProtocol {
    
    public typealias Model = CategoryModel
    
    private let repository: Repository<CategoryEntity>
    private let apiClient: APIClient
    
    public init(
        repository: Repository<CategoryEntity>,
        apiClient: APIClient
    ) {
        self.repository = repository
        self.apiClient = apiClient
        
    }
    
    public func load() async throws {
        let categories = try await apiClient.fetchCategories()
        
        try await upsert(categories)
    }
    
    public func getAll() async throws -> [Model] {
        try await repository.get().map { $0.toDomainModel }
    }
    
    public func getBy(entityId: String) async throws -> Model? {
        guard let model = try? await repository.get(for: entityId) else {
            return nil
        }
        
        return model.toDomainModel
    }
    
    public func insert(_ entity: Model) async throws {
        try await repository.insert(CategoryEntity.from(domainModel: entity))
    }
    
    public func upsert(_ entities: [Model]) async throws {
        try await repository.upsert(entities.map(CategoryEntity.from))
    }
    
    public func delete(_ entityId: String) async throws {
        guard let model = try? await repository.get(for: entityId) else {
            return
        }
        try await repository.remove(model)
    }
    
    public func observation() -> AsyncThrowingStream<[Model], Error> {
        return repository.stream.map { $0.map(\.toDomainModel) }.eraseToThrowingStream()
    }
}
