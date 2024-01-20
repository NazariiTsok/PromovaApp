//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation
import ComposableArchitecture
import Models

extension URL {
    public static var mock: Self {
        .init(string: "https://raw.githubusercontent.com/AppSci/promova-test-task-iOS/main/animals.json")!
    }
}

extension APIClient: DependencyKey {
    public static var liveValue: APIClient  {
        guard let urlString = Bundle.main.infoDictionary?["RepositoryURL"] as? String,
              let url = URL(string: urlString) else {
            return .live(url: .mock)
        }
        
        return .live(url: url)
    }
}

public struct APIClient {
    public var fetchCategories: @Sendable () async throws -> [CategoryModel]
}
