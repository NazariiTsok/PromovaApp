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

public struct CategoryDetailCellFeature: Reducer {
    public struct State: Equatable, Identifiable {
        
        public var id: Int {
            self.index
        }
        
        public let index: Int
        public let image: String
        public let title: String
        
        public init(
            item: FactModel,
            index: Int
        ){
            self.index = index
            self.image = item.image
            self.title = item.fact
            
        }
    }
    
    public enum Action: Equatable {
        
    }
    
    public init(){}
    
    public var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
