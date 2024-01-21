//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI
import RealmRepository
import Models

import APIClient

private enum CategoryClientProtocolKey: DependencyKey {
    
    static let testValue: CategoryClient = {
        @Dependency(\.apiClient) var apiClient
        
        let repository = Repository<CategoryEntity>()
        
        return CategoryClient(repository: repository, apiClient: apiClient)
    }()
    
    static let liveValue: CategoryClient = {
        @Dependency(\.apiClient) var apiClient
        
        let repository = Repository<CategoryEntity>()
        
        return CategoryClient(repository: repository, apiClient: apiClient)
    }()
}

extension DependencyValues {
    public var categoryClient: CategoryClient {
        get { self[CategoryClientProtocolKey.self] }
        set { self[CategoryClientProtocolKey.self] = newValue }
    }
}

public protocol CategoryClientProtocol {
    associatedtype Entity: Identifiable

    func load() async throws
    
    func getAll() async throws -> [Entity]
    func getBy(entityId: Entity.ID) async throws -> Entity?
    func insert(_ entity: Entity) async throws
    func upsert(_ entities: [Entity]) async throws
    func delete(_ entityId: Entity.ID) async throws
    
    func observation() -> AsyncThrowingStream<[Entity], Error>
}
