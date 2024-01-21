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
        
        public var item: FactModel
        public let index: Int
        
        public init(
            item: FactModel,
            index: Int
        ){
            self.item = item
            self.index = index
        }
    }
    
    public enum Action: Equatable {
        case onAppear
    }
    
    public init(){}
    
    public var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
