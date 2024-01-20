//
//  File.swift
//  
//
//  Created by Nazar Tsok on 20.01.2024.
//

import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay

#if DEBUG
extension APIClient: TestDependencyKey {
    public static let testValue = Self(
        fetchCategories: {
            unimplemented("\(Self.self).fetchCategories", placeholder: [])
        }
    )
}

#endif
