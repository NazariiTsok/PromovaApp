//
//  File.swift
//  
//
//  Created by Nazar Tsok on 21.01.2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Models

public struct CategoryDetailFeature: Reducer {
    public struct State: Equatable {
       
        public var category: CategoryModel
        
        public init(
            category: CategoryModel
        ) {
            self.category = category
        }
    }
    
    public enum Action: Equatable {
        
    }
    
    
    public init(){
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            default :
                return .none
            }
        }
    }
}
